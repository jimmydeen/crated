import Foundation
import SwiftUI

class SpotifyAPIService {
    static let clientID = "3df19c42306e4256863747c6f43bb7b3"
    static let clientSecret = "a94ede4677104b38a3c98333ac4c801c"
    static let searchRegion = "AU"
    
    private static var accessToken: String?
    private static var tokenExpirationDate: Date?
    private static let urlSession = URLSession(configuration: .default)
    
    private static func authenticate() async throws -> String {
        if let token = accessToken,
           let expirationDate = tokenExpirationDate,
           Date() < expirationDate {
            return token
        }
        
        let authKey = "\(clientID):\(clientSecret)"
        guard let authData = authKey.data(using: .utf8) else {
            throw SpotifyAPIError.FailedToRetrieveAccessToken
        }
        let authString = authData.base64EncodedString()
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.addValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SpotifyAPIError.InvalidResponse
        }
        
        guard let json = try JSONSerialization.jsonObject(
            with: data,
            options: []
        ) as? [String: Any],
              let accessToken = json["access_token"] as? String,
              let expiresIn = json["expires_in"] as? TimeInterval else {
            throw SpotifyAPIError.FailedToRetrieveAccessToken
        }
        
        self.accessToken = accessToken
        self.tokenExpirationDate = Date().addingTimeInterval(expiresIn)
        
        return accessToken
    }
    private static func getData(from url: URL) async throws -> Data {
        let token = try await authenticate()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await urlSession.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SpotifyAPIError.InvalidResponse
        }
        return data
    }
    private static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    public static func fetchAlbumDetails(albumID: String) async throws -> AlbumModel {
        let urlString = "https://api.spotify.com/v1/albums/\(albumID)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.InvalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumModel.self, from: data)
        return response.toModel()
    }
    public static func fetchAlbumsByArtist(artistID: String) async throws -> [AlbumModel] {
        let urlString = "https://api.spotify.com/v1/artists/\(artistID)/albums"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.InvalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumsModel.self, from: data)
        return response.items.map { $0.toModel() }
    }
    public static func fetchNewReleases(range: Range<Int>) async throws -> [AlbumModel] {
        let urlString = "https://api.spotify.com/v1/browse/new-releases?country=\(searchRegion)" +
        "&limit=\(range.upperBound)&offset=\(range.lowerBound)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.InvalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SearchResponseAlbumsModel.self, from: data)
        return response.albums.items.map { $0.toModel() }
    }
    public static func fetchTracks(album: AlbumModel) async throws -> [TrackModel] {
        let urlString = "https://api.spotify.com/v1/albums/\(album.id)/tracks"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.InvalidURL
        }
        let data = try await getData(from: url)
        let response = try decode(SpotifyAlbumTracksModel.self, from: data)
        return response.items.map { $0.toModel(for: album) }
    }
    public static func performSearch(
        query: String,
        type: SearchSegment,
        range: Range<Int>
    ) async throws -> [ResultProtocol] {
        let urlString = "https://api.spotify.com/v1/search?q=\(query)&type=\(type.stringValue)" +
        "&market=\(searchRegion)&limit=\(range.upperBound)&offset=\(range.lowerBound)"
        guard let url = URL(string: urlString) else {
            throw SpotifyAPIError.InvalidURL
        }
        let data = try await getData(from: url)
        
        switch type {
        case .Albums:
            let response = try decode(SearchResponseAlbumsModel.self, from: data)
            return response.albums.items.map { $0.toModel() }
        case .Artists:
            let response = try decode(SearchResponseArtistsModel.self, from: data)
            return response.artists.items.map { $0.toModel() }
        case .Tracks:
            let response = try decode(SearchResponseTracksModel.self, from: data)
            return response.tracks.items.map { $0.toModel() }
        }
    }
}

fileprivate struct SearchResponseAlbumsModel: Decodable {
    let albums: SpotifyAlbumsModel
}
fileprivate struct SearchResponseArtistsModel: Decodable {
    let artists: SpotifyArtistsModel
}
fileprivate struct SearchResponseTracksModel: Decodable {
    let tracks: SpotifyTracksModel
}

fileprivate struct SpotifyAlbumsModel: Decodable {
    let items: [SpotifyAlbumModel]
}
fileprivate struct SpotifyAlbumTracksModel: Decodable {
    let items: [SpotifyAlbumTrackModel]
}
fileprivate struct SpotifyArtistsModel: Decodable {
    let items: [SpotifyArtistFullModel]
}
fileprivate struct SpotifyTracksModel: Decodable {
    let items: [SpotifyTrackModel]
}

fileprivate struct SpotifyAlbumModel: Decodable {
    let album_type: String
    let artists: [SpotifyArtistModel]
    let id: String
    let images: [SpotifyAlbumImageModel]?
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
            type: album_type,
            release_date: release_date,
            spotify_link: "https://open.spotify.com/album/\(id)",
            image_url_hq: images?.first?.url,
            image_url_lq: images?.dropFirst().first?.url
        )
    }
}

fileprivate struct SpotifyAlbumTrackModel: Decodable {
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
            album_id: album.id,
            id: id,
            index: track_number,
            artists: artists.map { $0.name },
            image_url_hq: album.image_url_hq,
            image_url_lq: album.image_url_lq
        )
    }
}

fileprivate struct SpotifyArtistModel: Decodable {
    let id: String
    let name: String
    let popularity: Int?
    let type: String
    let uri: String
}

fileprivate struct SpotifyArtistFullModel: Decodable {
    let id: String
    let images: [SpotifyArtistImageModel]?
    let name: String
    let popularity: Int?
    let type: String
    let uri: String
    
    func toModel() -> ArtistModel {
        ArtistModel(
            name: name,
            id: id,
            artists: [],
            image_url_hq: images?.first?.url,
            image_url_lq: images?.dropFirst().first?.url
        )
    }
}

fileprivate struct SpotifyTrackModel: Decodable {
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
            album_id: album.id,
            id: id,
            index: track_number,
            artists: artists.map { $0.name },
            image_url_hq: album.images?.first?.url,
            image_url_lq: album.images?.dropFirst().first?.url
        )
    }
}

fileprivate struct SpotifyTrackAlbumInfoModel: Decodable {
    let images: [SpotifyAlbumImageModel]?
    let id: String
}
fileprivate struct SpotifyAlbumImageModel: Decodable {
    let height: Int
    let url: String
    let width: Int
}
fileprivate struct SpotifyArtistImageModel: Decodable {
    let height: Int
    let url: String
    let width: Int
}
fileprivate struct SpotifyRestrictionsModel: Decodable {
    let reason: String
}
