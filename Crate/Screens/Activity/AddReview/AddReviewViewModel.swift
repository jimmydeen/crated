import Foundation
import Observation

enum ReviewError: Error {
    case emptyTitle, emptyDescription
}

@Observable class AddReviewViewModel {
    var searchViewModel: SearchViewModel
    var currentlyReviewedAlbum: AlbumModel?
    var newReviewTitle: String = ""
    var newReviewDescription: String = ""
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }
}
