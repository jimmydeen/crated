import Foundation
import Observation

@Observable class SharedUserViewModel {
    var user: UserModel
    
    init() {
        user = UserModel(
            user_displayname: "Andre",
            user_name: "andredavisws",
            user_email: "andredavisws@gmail.com",
            user_location: "Melbourne, Victoria",
            user_follower_count: 0,
            user_following_count: 0,
            user_favorites: []
        )
    }
    public func addToFavorites(_ album: AlbumModel) {
        user.user_favorites.insert(album)
    }
    public func removeFromFavorites(_ album: AlbumModel) {
        user.user_favorites.remove(album)
    }
}
