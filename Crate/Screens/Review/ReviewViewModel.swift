import Foundation
import Observation

@Observable class ReviewViewModel {
    var currentlyReviewedAlbum: AlbumModel?
    var isCreatingReview: Bool = false
    var newReviewTitle: String = ""
    var newReviewDescription: String = ""
}
