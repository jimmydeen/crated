import Foundation
import SwiftUI

struct UserModel: Codable {
    let name: String
    let id: String
    let cover: String?
    let date_joined: Date
    var album_ratings: [String: Double]
    var favorite_albums: [String]
    var favorite_tracks: [String: [String]]
    var friends: [String]
    
    init(
        name: String,
        id: String,
        cover: String? = nil,
        date_joined: Date = .now,
        album_ratings: [String: Double] = [:],
        favorite_albums: [String] = [],
        favorite_tracks: [String: [String]] = [:],
        friends: [String] = []
    ) {
        self.name = name
        self.id = id
        self.cover = cover
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
        self.cover = try container.decodeIfPresent(String.self, forKey: .cover)
        
        // Handle date conversion from timestamp
        let timestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .date_joined)
        self.date_joined = Date(timeIntervalSince1970: timestamp ?? Date().timeIntervalSince1970)
        
        self.album_ratings = try container.decodeIfPresent([String: Double].self, forKey: .album_ratings) ?? [:]
        self.favorite_albums = try container.decodeIfPresent([String].self, forKey: .favorite_albums) ?? []
        self.favorite_tracks = try container.decodeIfPresent([String: [String]].self, forKey: .favorite_tracks) ?? [:]
        self.friends = try container.decodeIfPresent([String].self, forKey: .friends) ?? []
    }
}
