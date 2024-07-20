import Foundation
import Observation

@Observable class HomeViewModel {
    var albums: [AlbumModel] = []
    
    @MainActor
    public func fetchAlbums() async {
        let response = await SpotifyAPIService.retrieveLatestAlbums(
            from: albums.count,
            to: albums.count + 30
        )
        for album in response {
            self.albums.append(album)
        }
    }
}
