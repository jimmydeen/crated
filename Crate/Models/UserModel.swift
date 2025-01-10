import Foundation

class UserModel: Codable {
    let name: String
    let cover: URL?
    let date_joined: Date
    var album_ratings: [String: Double]
    var favorite_albums: [String]
    var favorite_tracks: [String: [String]]
    let location_longitude: Double?
    let location_latitude: Double?
    let id: UUID
    let profile_id: UUID
    
    init(
        name: String,
        cover: URL?,
        date_joined: Date,
        album_ratings: [String: Double],
        favorite_albums: [String],
        favorite_tracks: [String: [String]],
        location_longitude: Double?,
        location_latitude: Double?,
        id: UUID,
        profile_id: UUID
    ) {
        self.name = name
        self.cover = cover
        self.date_joined = date_joined
        self.album_ratings = album_ratings
        self.favorite_albums = favorite_albums
        self.favorite_tracks = favorite_tracks
        self.location_longitude = location_longitude
        self.location_latitude = location_latitude
        self.id = id
        self.profile_id = profile_id
    }
}
