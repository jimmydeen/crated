import Foundation
import Observation

@Observable class ReviewsViewModel: UserViewModel {
    let metadata: MetadataService = .shared
    
    var reviews: [AlbumModel: ReviewModel] = [:]
    
    public func fetchReviews() async {
        do {
            let reviews = try await user.retrieveReviews()
            
            for review in reviews {
                let album = try await metadata.fetchAlbumDetails(albumID: review.album)
                self.reviews.updateValue(review, forKey: album)
            }
        } catch {
            print(error)
        }
    }
}
