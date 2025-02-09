import Foundation
import Observation

@Observable class FavoritesViewModel {
    let metadata: MetadataService = .shared
    let user: UserService = .shared
    
    private(set) var favorites: [Album] = []
    private(set) var isLoading: Bool = true
    
    public func fetchFavorites() async {
        guard favorites.isEmpty else { return }
        defer { isLoading = false }
        
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
