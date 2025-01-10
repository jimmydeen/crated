import Foundation

enum ActivityType {
    case albumRating, albumReview, favoriteAdd, friendAdded
}

struct ActivityModel {
    let id: UUID
    let timestamp: Date
    let type: ActivityType
    let album_id: String?
    let friend_id: String?
    let rating: Double?
    let user_id: String?
    
    var description: String {
        switch type {
        case .albumRating:
            let count = floor(rating ?? 0)
            return "\(user_id ?? "Someone") rated \(album_id ?? "an album") \(String(repeating: "★", count: Int(count)))\(rating == count ? "" : "½")."
        case .albumReview:
            return "\(user_id ?? "Someone") reviewed \(album_id ?? "an album")"
        case .favoriteAdd:
            return "\(user_id ?? "Someone") added \(album_id ?? "an album") to their favorites."
        case .friendAdded:
            return "You became friends with \(friend_id ?? "someone")."
        }
    }
}
