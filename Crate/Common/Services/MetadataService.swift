import Foundation

class MetadataService {
    static let shared = MetadataService()
    
    private let clientID = "3df19c42306e4256863747c6f43bb7b3"
    private let clientSecret = "a94ede4677104b38a3c98333ac4c801c"
    private let clientRegion = "AU"
    
    private let userSession = URLSession(configuration: .default)
    private var userToken: String?
    private var userTokenExpiry: Date?
    
    private init() {}
    
    private func authenticate() async throws -> String {
        if let token = userToken,
           let expiry = userTokenExpiry,
           Date.now < expiry {
            return token
        }
        
        let authKey = "\(clientID):\(clientSecret)"
        guard let authData = authKey.data(using: .utf8) else {
            throw SpotifyAPIError.failedToRetrieveToken
        }
        let authString = authData.base64EncodedString()
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.addValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        let (data, response) = try await userSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SpotifyAPIError.invalidResponse
        }
        
        guard let json = try JSONSerialization.jsonObject(
            with: data,
            options: []
        ) as? [String: Any],
              let token = json["access_token"] as? String,
              let expiresIn = json["expires_in"] as? TimeInterval else {
            throw SpotifyAPIError.failedToRetrieveToken
        }
        
        userToken = token
        userTokenExpiry = Date().addingTimeInterval(expiresIn)
        
        return token
    }
    
    private func getData(from url: URL) async throws -> Data {
        let token = try await authenticate()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await userSession.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SpotifyAPIError.invalidResponse
        }
        return data
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func fetchAlbumDetails(albumID: String) async throws -> Album {
        let urlString = "https://api.spotify.com/v1/albums/\(albumID)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbum.self, from: data)
        return response.toModel()
    }
    
    func fetchAlbumsByArtist(artistID: String) async throws -> [Album] {
        let urlString = "https://api.spotify.com/v1/artists/\(artistID)/albums"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbums.self, from: data)
        return response.items.map { $0.toModel() }
    }
    
    func fetchNewReleases(range: Range<Int>) async throws -> [Album] {
        let urlString = "https://api.spotify.com/v1/browse/new-releases?country=\(clientRegion)&limit=\(range.count)&offset=\(range.lowerBound)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SearchResponseAlbums.self, from: data)
        return response.albums.items.map { $0.toModel() }
    }
    
    func fetchTracks(album: Album) async throws -> [Track] {
        let urlString = "https://api.spotify.com/v1/albums/\(album.id)/tracks"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumTracks.self, from: data)
        return response.items.map { $0.toModel(for: album) }
    }
    
    func search(query: String, type: SearchSegment, page: Int, batchSize: Int) async throws -> [SearchResult] {
        let urlString = "https://api.spotify.com/v1/search?q=\(query)&type=\(type.rawValue)&market=\(clientRegion)&limit=\(batchSize)&offset=\((page - 1)*batchSize)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        
        switch type {
        case .album:
            let response = try decode(SearchResponseAlbums.self, from: data)
            return response.albums.items.map { $0.toModel() }
        case .artist:
            let response = try decode(SearchResponseArtists.self, from: data)
            return response.artists.items.map { $0.toModel() }
        default:
            let response = try decode(SearchResponseTracks.self, from: data)
            return response.tracks.items.map { $0.toModel() }
        }
    }
    
    // MARK: Errors
    
    private enum SpotifyAPIError: Error {
        case failedToRetrieveToken, invalidResponse, invalidURL
    }
    
    // MARK: Intermediary Models
    
    private struct SearchResponseAlbums: Decodable {
        let albums: SpotifyAlbums
    }
    
    private struct SearchResponseArtists: Decodable {
        let artists: SpotifyArtists
    }
    
    private struct SearchResponseTracks: Decodable {
        let tracks: SpotifyTracks
    }
    
    private struct SpotifyAlbums: Decodable {
        let items: [SpotifyAlbum]
    }
    
    private struct SpotifyAlbumTracks: Decodable {
        let items: [SpotifyAlbumTrack]
    }
    
    private struct SpotifyArtists: Decodable {
        let items: [SpotifyArtistFull]
    }
    
    private struct SpotifyTracks: Decodable {
        let items: [SpotifyTrack]
    }
    
    private struct SpotifyAlbum: Decodable {
        let album_type: String
        let artists: [SpotifyArtist]
        let id: String
        let images: [SpotifyAlbumImage]
        let name: String
        let popularity: Int?
        let release_date: String
        let release_date_precision: String
        let type: String
        let uri: String
        
        func toModel() -> Album {
            Album(
                name: name,
                id: id,
                artists: artists.map { $0.name },
                cover_hq: URL(string: images.first!.url)!,
                cover_lq: URL(string: images.last!.url)!,
                type: Album.AlbumType(rawValue: album_type)!,
                date: DateUtilities.formatStringToDate(date: release_date, precision: DatePrecision(rawValue: release_date_precision)!),
                date_precision: DatePrecision(rawValue: release_date_precision)!,
                spotify_link: URL(string: "https://open.spotify.com/album/\(id)")!
            )
        }
    }
    
    private struct SpotifyAlbumTrack: Decodable {
        let artists: [SpotifyArtist]
        let disc_number: Int
        let duration_ms: Int
        let explicit: Bool
        let id: String
        let name: String
        let popularity: Int?
        let track_number: Int
        let type: String
        let uri: String
        let is_local: Bool
        
        func toModel(for album: Album) -> Track {
            Track(
                name: name,
                id: id,
                artists: artists.map { $0.name },
                cover: album.cover_lq,
                album_id: album.id,
                index: track_number
            )
        }
    }
    
    private struct SpotifyArtist: Decodable {
        let id: String
        let name: String
        let popularity: Int?
        let type: String
        let uri: String
    }
    
    private struct SpotifyArtistFull: Decodable {
        let id: String
        let images: [SpotifyArtistImage]
        let name: String
        let popularity: Int?
        let type: String
        let uri: String
        
        func toModel() -> Artist {
            let coverHQ = images.first?.url != nil ? URL(string: images.first!.url) : nil
            let coverLQ = images.last?.url != nil ? URL(string: images.last!.url) : nil
            
            return Artist(
                name: name,
                id: id,
                cover_hq: coverHQ,
                cover_lq: coverLQ
            )
        }
    }
    
    private struct SpotifyTrack: Decodable {
        let album: SpotifyTrackAlbumInfo
        let artists: [SpotifyArtist]
        let disc_number: Int
        let duration_ms: Int
        let explicit: Bool
        let id: String
        let name: String
        let popularity: Int?
        let track_number: Int
        let type: String
        let uri: String
        let is_local: Bool
        
        func toModel() -> Track {
            Track(
                name: name,
                id: id,
                artists: artists.map { $0.name },
                cover: URL(string: album.images.last!.url)!,
                album_id: album.id,
                index: track_number
            )
        }
    }
    
    private struct SpotifyTrackAlbumInfo: Decodable {
        let images: [SpotifyAlbumImage]
        let id: String
    }
    
    private struct SpotifyAlbumImage: Decodable {
        let height: Int
        let url: String
        let width: Int
    }
    
    private struct SpotifyArtistImage: Decodable {
        let height: Int
        let url: String
        let width: Int
    }
    
    private struct SpotifyRestrictions: Decodable {
        let reason: String
    }
}
