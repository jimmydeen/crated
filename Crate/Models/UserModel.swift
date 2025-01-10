import Foundation

struct UserModel: Codable {
    let name: String
    let cover: String?
    let date_joined: Date
    var album_ratings: [String: Double]
    var favorite_albums: [String]
    var favorite_tracks: [String: [String]]
    var friends: [String]
    let lists: [String]
    let location_longitude: Double?
    let location_latitude: Double?
    let id: String
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return dictionary ?? [:]
    }
}
