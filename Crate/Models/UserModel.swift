import Foundation

class UserModel: NSObject {
    let user_id: String = UUID().uuidString
    let user_displayname: String
    let user_name: String
    let user_email: String
    let user_location: String
    
    var user_follower_count: Int
    var user_following_count: Int
    var user_favorites: Set<AlbumModel>
    
    init(
        user_displayname: String,
        user_name: String,
        user_email: String,
        user_location: String,
        user_follower_count: Int,
        user_following_count: Int,
        user_favorites: Set<AlbumModel>
    ) {
        self.user_displayname = user_displayname
        self.user_name = user_name
        self.user_email = user_email
        self.user_location = user_location
        self.user_follower_count = user_follower_count
        self.user_following_count = user_following_count
        self.user_favorites = user_favorites
    }
}
