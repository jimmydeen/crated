import Foundation
import Observation

@Observable class ListViewModel {
    let list: ListModel
    let metadata: MetadataService = .shared
    
    var albums: [AlbumModel] = []
    
    init(list: ListModel) {
        self.list = list
    }
    
    func fetchAlbums() async {
        do {
            for id in list.albums {
                let album = try await metadata.fetchAlbumDetails(albumID: id)
                albums.append(album)
            }
        } catch {
            print(error)
        }
    }
}
