import Foundation
import Observation

@Observable class ListViewModel {
    let list: ListModel
    
    var albums: [AlbumModel] = []
    
    init(list: ListModel) {
        self.list = list
    }
    
    func fetchAlbums() async {
        do {
            for albumID in list.albums {
                let album = try await MusicMetadataAPIService.fetchAlbumDetails(albumID: albumID)
                albums.append(album)
            }
        } catch {
            print(error)
        }
    }
}
