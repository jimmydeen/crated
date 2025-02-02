import Foundation
import Observation

@Observable class CrateViewModel {
    private let metadata: MetadataService = .shared
    private let user: UserService = .shared
    
    let crate: Crate
    
    private(set) var albums: [Album] = []
    
    var search = Search()
    
    init(crate: Crate) {
        self.crate = crate
    }
    
    func addAlbum(album: SearchResult) {
        Task {
            do {
                let album = album as! Album
                try await user.addToCrate(album: album, crate: crate)
                albums.append(album)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchAlbums() async {
        do {
            for id in crate.albums {
                let album = try await metadata.fetchAlbumDetails(albumID: id)
                albums.append(album)
            }
        } catch {
            print(error)
        }
    }
}
