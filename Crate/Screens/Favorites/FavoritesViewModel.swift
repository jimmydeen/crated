import Foundation
import Observation

@Observable class FavoritesViewModel: UserViewModel {
    let metadata: MetadataService = .shared
    
    var favorites: [AlbumModel] = []
    
    public func fetchFavorites() async {
        do {
            let albums = try await user.retrieveFavoriteAlbums()
            for album in albums {
                let album = try await metadata.fetchAlbumDetails(albumID: album)
                favorites.append(album)
            }
        } catch {
            print(error)
        }
    }
}
