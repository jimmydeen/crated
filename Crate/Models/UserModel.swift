import Foundation
import SwiftUI

struct UserModel: Codable, SearchResult {
    let name: String
    let id: String
    var cover_hq: URL?
    var cover_lq: URL?
    let date_joined: Date
    var album_ratings: [String: Double]
    var favorite_albums: [String]
    var favorite_tracks: [String: [String]]
    var friends: [String]
    
    init(
        name: String,
        id: String = UUID().uuidString,
        cover_hq: URL? = nil,
        cover_lq: URL? = nil,
        date_joined: Date = .now,
        album_ratings: [String: Double] = [:],
        favorite_albums: [String] = [],
        favorite_tracks: [String: [String]] = [:],
        friends: [String] = []
    ) {
        self.name = name
        self.id = id
        self.cover_hq = cover_hq
        self.cover_lq = cover_lq
        self.date_joined = date_joined
        self.album_ratings = album_ratings
        self.favorite_albums = favorite_albums
        self.favorite_tracks = favorite_tracks
        self.friends = friends
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        let cover_hq = try container.decodeIfPresent(String.self, forKey: .cover_hq)
        let cover_lq = try container.decodeIfPresent(String.self, forKey: .cover_lq)
        
        if cover_hq != nil {
            self.cover_hq = URL(string: cover_hq!)
        }
        if cover_lq != nil {
            self.cover_lq = URL(string: cover_lq!)
        }
        
        let timestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .date_joined)
        self.date_joined = Date(timeIntervalSince1970: timestamp ?? Date().timeIntervalSince1970)
        
        self.album_ratings = try container.decodeIfPresent([String: Double].self, forKey: .album_ratings) ?? [:]
        self.favorite_albums = try container.decodeIfPresent([String].self, forKey: .favorite_albums) ?? []
        self.favorite_tracks = try container.decodeIfPresent([String: [String]].self, forKey: .favorite_tracks) ?? [:]
        self.friends = try container.decodeIfPresent([String].self, forKey: .friends) ?? []
    }
    
    var subtitle: String {
        return ""
    }
    
    func searchView() -> AnyView {
        return AnyView(Text(name))
    }
}
