import Foundation
import SwiftUI
import Observation

class HomeViewModel: ObservableObject {
    @Published var albums: [AlbumModel] = []
    
    init() {
        Task.detached {
            await self.fetchAlbums()
        }
    }
    
    @MainActor
    public func fetchAlbums() async {
        let tempAlbums = await SpotifyAPIService.retrieveLatestAlbums(from: 0, to: 48)
        self.albums.append(contentsOf: tempAlbums)
    }
    
    @MainActor
    public func addAlbums() async {
        let tempAlbums = await SpotifyAPIService.retrieveLatestAlbums(
            from: albums.count,
            to: albums.count + 48
        )
        self.albums.append(contentsOf: tempAlbums)
    }
}
