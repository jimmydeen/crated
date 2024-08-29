import Foundation
import Observation

@Observable class NewReviewViewModel {
    var currentlyReviewedAlbum: AlbumModel?
    var isCreatingReview: Bool = false
    var newReviewTitle: String = ""
    var newReviewDescription: String = ""
}
