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
            print(url)
            throw SpotifyAPIError.invalidResponse
        }
        return data
    }
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    public func fetchAlbumDetails(albumID: String) async throws -> AlbumModel {
        let urlString = "https://api.spotify.com/v1/albums/\(albumID)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumModel.self, from: data)
        return response.toModel()
    }
    public func fetchAlbumsByArtist(artistID: String) async throws -> [AlbumModel] {
        let urlString = "https://api.spotify.com/v1/artists/\(artistID)/albums"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumsModel.self, from: data)
        return response.items.map { $0.toModel() }
    }
    public func fetchNewReleases(range: Range<Int>) async throws -> [AlbumModel] {
        let urlString = "https://api.spotify.com/v1/browse/new-releases?country=\(clientRegion)&limit=\(range.count)&offset=\(range.lowerBound)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SearchResponseAlbumsModel.self, from: data)
        return response.albums.items.map { $0.toModel() }
    }
    public func fetchTracks(album: AlbumModel) async throws -> [TrackModel] {
        let urlString = "https://api.spotify.com/v1/albums/\(album.id)/tracks"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumTracksModel.self, from: data)
        return response.items.map { $0.toModel(for: album) }
    }
    public func search(
        query: String,
        type: SearchSegment,
        page: Int,
        batchSize: Int
    ) async throws -> [SearchResult] {
        let urlString = "https://api.spotify.com/v1/search?q=\(query)&type=\(type.rawValue)&market=\(clientRegion)&limit=\(batchSize)&offset=\(page*batchSize)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.invalidURL
        }
        let data = try await getData(from: url)
        
        switch type {
        case .album:
            let response = try decode(SearchResponseAlbumsModel.self, from: data)
            return response.albums.items.map { $0.toModel() }
        case .artist:
            let response = try decode(SearchResponseArtistsModel.self, from: data)
            return response.artists.items.map { $0.toModel() }
        default:
            let response = try decode(SearchResponseTracksModel.self, from: data)
            return response.tracks.items.map { $0.toModel() }
        }
    }
    
    // MARK: Errors
    
    private enum SpotifyAPIError: Error {
        case failedToRetrieveToken, invalidResponse, invalidURL
    }
    
    // MARK: Intermediary Models
    
    private struct SearchResponseAlbumsModel: Decodable {
        let albums: SpotifyAlbumsModel
    }
    private struct SearchResponseArtistsModel: Decodable {
        let artists: SpotifyArtistsModel
    }
    private struct SearchResponseTracksModel: Decodable {
        let tracks: SpotifyTracksModel
    }
    private struct SpotifyAlbumsModel: Decodable {
        let items: [SpotifyAlbumModel]
    }
    private struct SpotifyAlbumTracksModel: Decodable {
        let items: [SpotifyAlbumTrackModel]
    }
    private struct SpotifyArtistsModel: Decodable {
        let items: [SpotifyArtistFullModel]
    }
    private struct SpotifyTracksModel: Decodable {
        let items: [SpotifyTrackModel]
    }
    private struct SpotifyAlbumModel: Decodable {
        let album_type: String
        let artists: [SpotifyArtistModel]
        let id: String
        let images: [SpotifyAlbumImageModel]
        let name: String
        let popularity: Int?
        let release_date: String
        let release_date_precision: String
        let type: String
        let uri: String
        
        func toModel() -> AlbumModel {
            AlbumModel(
                name: name,
                id: id,
                artists: artists.map { $0.name },
                cover_hq: URL(string: images.first!.url)!,
                cover_lq: URL(string: images.last!.url)!,
                type: AlbumModel.AlbumType(rawValue: album_type)!,
                date: DateUtilities.formatStringToDate(date: release_date, precision: DatePrecision(rawValue: release_date_precision)!),
                date_precision: DatePrecision(rawValue: release_date_precision)!,
                spotify_link: URL(string: "https://open.spotify.com/album/\(id)")!
            )
        }
    }
    private struct SpotifyAlbumTrackModel: Decodable {
        let artists: [SpotifyArtistModel]
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
        
        func toModel(for album: AlbumModel) -> TrackModel {
            TrackModel(
                name: name,
                id: id,
                artists: artists.map { $0.name },
                cover_hq: album.cover_lq,
                cover_lq: album.cover_hq,
                album_id: album.id,
                index: track_number
            )
        }
    }
    private struct SpotifyArtistModel: Decodable {
        let id: String
        let name: String
        let popularity: Int?
        let type: String
        let uri: String
    }
    private struct SpotifyArtistFullModel: Decodable {
        let id: String
        let images: [SpotifyArtistImageModel]
        let name: String
        let popularity: Int?
        let type: String
        let uri: String
        
        func toModel() -> ArtistModel {
            let coverHQ = images.first?.url != nil ? URL(string: images.first!.url) : nil
            let coverLQ = images.last?.url != nil ? URL(string: images.last!.url) : nil
            
            return ArtistModel(
                name: name,
                id: id,
                cover_hq: coverHQ,
                cover_lq: coverLQ
            )
        }
    }
    private struct SpotifyTrackModel: Decodable {
        let album: SpotifyTrackAlbumInfoModel
        let artists: [SpotifyArtistModel]
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
        
        func toModel() -> TrackModel {
            TrackModel(
                name: name,
                id: id,
                artists: artists.map { $0.name },
                cover_hq: URL(string: album.images.first!.url)!,
                cover_lq: URL(string: album.images.last!.url)!,
                album_id: album.id,
                index: track_number
            )
        }
    }
    private struct SpotifyTrackAlbumInfoModel: Decodable {
        let images: [SpotifyAlbumImageModel]
        let id: String
    }
    private struct SpotifyAlbumImageModel: Decodable {
        let height: Int
        let url: String
        let width: Int
    }
    private struct SpotifyArtistImageModel: Decodable {
        let height: Int
        let url: String
        let width: Int
    }
    private struct SpotifyRestrictionsModel: Decodable {
        let reason: String
    }
}
