import Foundation
import SwiftUI

class SpotifyAPIService {
    static let clientID = "3df19c42306e4256863747c6f43bb7b3"
    static let clientSecret = "a94ede4677104b38a3c98333ac4c801c"
    static let searchRegion = "AU"
    
    private static var accessToken: String?
    private static var tokenExpirationDate: Date?
    private static let urlSession = URLSession(configuration: .default)
    
    // Authentication
    private static func authenticate() async throws -> String {
        if let token = accessToken, let expirationDate = tokenExpirationDate, Date() < expirationDate {
            return token
        }
        
        let authKey = "\(clientID):\(clientSecret)"
        guard let authData = authKey.data(using: .utf8) else {
            throw SpotifyError.AuthenticationFailed
        }
        let authString = authData.base64EncodedString()
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.addValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SpotifyError.InvalidResponse
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let accessToken = json["access_token"] as? String,
              let expiresIn = json["expires_in"] as? TimeInterval else {
            throw SpotifyError.AuthenticationFailed
        }
        
        self.accessToken = accessToken
        self.tokenExpirationDate = Date().addingTimeInterval(expiresIn)
        
        return accessToken
    }
    
    private static func retrieveData(from url: URL) async throws -> Data {
        let token = try await authenticate()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await urlSession.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SpotifyError.InvalidResponse
        }
        return data
    }
    private static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    static func retrieveLatestAlbums(from start: Int, to end: Int) async -> [AlbumModel] {
        do {
            let url = URL(string: "https://api.spotify.com/v1/browse/new-releases?country=\(searchRegion)&limit=\(end - start)&offset=\(start)")!
            let data = try await retrieveData(from: url)
            let response = try decode(SearchResponseAlbumsModel.self, from: data)
            return response.albums.items.map { $0.toModel() }
        } catch {
            print(error)
            return []
        }
    }
    static func retrieveTracks(for album: AlbumModel) async -> [TrackModel] {
        do {
            let url = URL(string: "https://api.spotify.com/v1/albums/\(album.album_id)/tracks")!
            let data = try await retrieveData(from: url)
            let response = try decode(SpotifyAlbumTracksModel.self, from: data)
            return response.items.map { $0.toModel(for: album) }
        } catch {
            print(error)
            return []
        }
    }
    static func retrieveSearch(for query: String, ofType type: SearchSegment, from start: Int, to end: Int) async -> [IdentifiableProtocol] {
        do {
            let url = URL(string: "https://api.spotify.com/v1/search?q=\(query)&type=\(type.rawValue)&market=\(searchRegion)&limit=\(end - start)&offset=\(start)")!
            let data = try await retrieveData(from: url)
            
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
        } catch {
            print(error)
            return []
        }
    }
}

// MARK: Data Transfer Objects for Spotify API - Search Responses
fileprivate struct SearchResponseAlbumsModel: Decodable {
    let albums: SpotifyAlbumsModel
}
fileprivate struct SearchResponseArtistsModel: Decodable {
    let artists: SpotifyArtistsModel
}
fileprivate struct SearchResponseTracksModel: Decodable {
    let tracks: SpotifyTracksModel
}

// MARK: Data Transfer Objects for Spotify API - Intermediate Keys
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

// MARK: Data Transfer Objects for Spotify API - Object Models
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
            album_name: name,
            album_artists: artists.map { $0.name },
            album_id: id,
            album_type: album_type,
            album_release_date: release_date,
            album_cover_url_high_quality: images?.first?.url,
            album_cover_url_low_quality: images?.dropFirst().first?.url
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
            album_id: album.album_id,
            track_id: id,
            track_name: name,
            track_index: track_number,
            track_artists: artists.map { $0.name },
            track_image_url_high_quality: album.album_cover_url_high_quality,
            track_image_url_low_quality: album.album_cover_url_low_quality
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
            artist_name: name,
            artist_id: id,
            artist_image_url_high_quality: images?.first?.url,
            artist_image_url_low_quality: images?.dropFirst().first?.url
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
            album_id: album.id,
            track_id: id,
            track_name: name,
            track_index: track_number,
            track_artists: artists.map { $0.name },
            track_image_url_high_quality: album.images?.first?.url,
            track_image_url_low_quality: album.images?.dropFirst().first?.url
        )
    }
}

// MARK: Data Transfer Objects for Spotify API - Nested Structures
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
