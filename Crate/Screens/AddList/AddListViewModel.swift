import UIKit
import Observation

@Observable class AddListViewModel {
    var name: String = ""
    var profileImage: UIImage?
    var albums: [AlbumModel] = []
}
