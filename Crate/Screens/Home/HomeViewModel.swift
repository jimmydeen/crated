import Foundation
import Observation

@Observable class HomeViewModel {
    var albums: [AlbumModel] = []
    
    @MainActor public func fetchAlbums() async {
        do {
            let response = try await SpotifyAPIService.retrieveLatestAlbums(
                from: albums.count,
                to: albums.count + 30
            )
            for album in response {
                self.albums.append(album)
            }
        } catch {
            print(error)
        }
    }
}
