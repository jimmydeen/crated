import Foundation
import SwiftUI

struct User: Codable, SearchResult {
    let username: String
    let id: String
    let avatar: String?
    let date_joined: Date
    let friends: [String]
    let favorite_albums: [String]
    let favorite_tracks: [String: [String]]
    let ratings: [String: Double]
    
    var cover: URL? {
        if avatar != nil {
            URL(string: avatar!)
        } else {
            nil
        }
    }
    
    var name: String {
        return username
    }
    
    var subtitle: String? { nil }
    
    init(
        username: String,
        id: String = UUID().uuidString,
        avatar: String? = nil,
        date_joined: Date = .now,
        friends: [String] = [],
        favorite_albums: [String] = [],
        favorite_tracks: [String: [String]] = [:],
        ratings: [String: Double] = [:],
        reviews: [String: String] = [:]
    ) {
        self.username = username
        self.id = id
        self.avatar = avatar
        self.date_joined = date_joined
        self.friends = friends
        self.favorite_albums = favorite_albums
        self.favorite_tracks = favorite_tracks
        self.ratings = ratings
    }
    
    func searchView() -> AnyView {
        return AnyView(UserView(viewModel: UserViewModel(profile: self)))
    }
}
