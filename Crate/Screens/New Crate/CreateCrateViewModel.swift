import UIKit
import Observation

@Observable class CreateCrateViewModel {
    private let user: UserService = .shared
    
    private(set) var albums: [Album] = []
    private(set) var profileImage: UIImage?
    
    var name = ""
    var search = Search()
    
    func addAlbum(album: SearchResult) {
        if let album = album as? Album {
            albums.append(album)
        }
    }
    
    func createCrate() {
        do {
            try user.createCrate(name: name, cover: albums.first?.cover_lq ?? nil, albums: albums.map { $0.id })
        } catch {
            print(error)
        }
    }
}
