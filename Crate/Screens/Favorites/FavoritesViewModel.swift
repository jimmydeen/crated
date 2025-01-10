import Foundation
import Observation

@Observable class FavoritesViewModel {
    var favorites: [AlbumModel] = []
    
    let userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    
    public func fetchFavorites() async {
        do {
            for album in userViewModel.currentUser?.favorite_albums ?? [] {
                let album = try await MusicMetadataAPIService.fetchAlbumDetails(albumID: album)
                favorites.append(album)
            }
        } catch {
            print(error)
        }
    }
}
