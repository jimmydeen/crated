import Foundation
import SwiftUI

// TODO: Make into singleton using more formal syntax
class SpotifyAPIService {
    static let clientID = "3df19c42306e4256863747c6f43bb7b3"
    static let clientSecret = "a94ede4677104b38a3c98333ac4c801c"
    static let searchRegion = "AU"
    
    private static var accessToken: String?
    private static var tokenExpirationDate: Date?
    
    static func authenticate() async throws -> String {
        if let token = accessToken, let expirationDate = tokenExpirationDate, Date() < expirationDate {
            return token
        }
        
        let authKey = "\(clientID):\(clientSecret)"
        let authString = authKey.data(using: .utf8)!.base64EncodedString()
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.addValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
    static func retrieveLatestAlbums(from start: Int, to end: Int) async -> [AlbumModel] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/browse/new-releases/"
        components.queryItems = [
            URLQueryItem(name: "country", value: searchRegion),
            URLQueryItem(name: "limit", value: String(end - start)),
            URLQueryItem(name: "offset", value: String(start))
        ]
        
        do {
            let requestToken = try await authenticate()
            var requestURL = URLRequest(url: components.url!)
            requestURL.httpMethod = "GET"
            requestURL.setValue("Bearer \(requestToken)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: requestURL)
            
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(SearchResponseAlbumsModel.self, from: data)
            
            return searchResponse.albums.items.map { album in
                AlbumModel(
                    album_name: album.name,
                    album_artists: album.artists.map { $0.name },
                    album_id: album.id,
                    album_type: album.album_type,
                    album_release_date: album.release_date,
                    album_image_url_hq: album.images[0].url,
                    album_image_url_lq: album.images[1].url
                )
            }
        }
        catch let error {
            print(error)
            return []
        }
    }
    static func retrieveTracks(for album: AlbumModel) async -> [TrackModel] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/albums/\(album.album_id)/tracks"
        
        do {
            let requestToken = try await authenticate()
            var requestURL = URLRequest(url: components.url!)
            requestURL.httpMethod = "GET"
            requestURL.setValue("Bearer \(requestToken)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: requestURL)
            
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(SpotifyAlbumTracksModel.self, from: data)
            
            // MARK: Remember to change the hq and lq image url properties for artists and tracks to optional.
            return searchResponse.items.map { track in
                TrackModel(
                    album_id: album.album_id,
                    track_id: track.id,
                    track_name: track.name,
                    track_index: track.track_number,
                    track_artists: track.artists.map { $0.name },
                    track_image_url_hq: "",
                    track_image_url_lq: ""
                )
            }
        }
        catch let error {
            print(error)
            return []
        }
    }
    static func retrieveSearch(for query: String, ofType type: String, from start: Int, to end: Int) async -> [IdentifiableModel] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/search/"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: type),
            URLQueryItem(name: "market", value: searchRegion),
            URLQueryItem(name: "limit", value: String(end - start)),
            URLQueryItem(name: "offset", value: String(start))
        ]
        
        do {
            let requestToken = try await authenticate()
            var requestURL = URLRequest(url: components.url!)
            requestURL.httpMethod = "GET"
            requestURL.setValue("Bearer \(requestToken)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: requestURL)
            
            let decoder = JSONDecoder()
            if type == "album" {
                let searchResponse = try decoder.decode(SearchResponseAlbumsModel.self, from: data)
                let sortedAlbums = searchResponse.albums.items.sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
                
                return sortedAlbums.map { album in
                    AlbumModel(
                        album_name: album.name,
                        album_artists: album.artists.map { $0.name },
                        album_id: album.id,
                        album_type: album.album_type,
                        album_release_date: album.release_date,
                        album_image_url_hq: album.images[0].url,
                        album_image_url_lq: album.images[1].url
                    )
                }
            } else if type == "artist" {
                let searchResponse = try decoder.decode(SearchResponseArtistsModel.self, from: data)
                let sortedArtists = searchResponse.artists.items.sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
                
                // TODO: Fix the hacky solution below.
                return sortedArtists.map { artist in
                    if artist.images.isEmpty {
                        ArtistModel(
                            artist_name: artist.name,
                            artist_id: artist.id,
                            artist_image_url_hq: "",
                            artist_image_url_lq: ""
                        )
                    } else {
                        ArtistModel(
                            artist_name: artist.name,
                            artist_id: artist.id,
                            artist_image_url_hq: artist.images[0]!.url,
                            artist_image_url_lq: artist.images[1]!.url
                        )
                    }
                }
            } else {
                let searchResponse = try decoder.decode(SearchResponseTracksModel.self, from: data)
                let sortedTracks = searchResponse.tracks.items.sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
                
                return sortedTracks.map { track in
                    TrackModel(
                        album_id: track.album.id,
                        track_id: track.id,
                        track_name: track.name,
                        track_index: track.track_number,
                        track_artists: track.artists.map { $0.name },
                        track_image_url_hq: track.album.images[0].url,
                        track_image_url_lq: track.album.images[1].url
                    )
                }
            }
        }
        catch let error {
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
    let images: [SpotifyAlbumImageModel]
    let name: String
    let popularity: Int?
    let release_date: String
    let release_date_precision: String
    let type: String
    let uri: String
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
    let images: [SpotifyArtistImageModel?]
    let name: String
    let popularity: Int?
    let type: String
    let uri: String
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
}

// MARK: Data Transfer Objects for Spotify API - Nested Structures
fileprivate struct SpotifyTrackAlbumInfoModel: Decodable {
    let images: [SpotifyAlbumImageModel]
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
