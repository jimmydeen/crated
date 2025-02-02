import Foundation
import Observation

@Observable class CreateReviewViewModel {
    private let metadata: MetadataService = .shared
    private let user: UserService = .shared
    
    private(set) var album: Album?
    
    var description = ""
    var rating: Double = 0
    var search = Search()
    var tab: ReviewTab = .search
    var title = ""
    
    func publishReview() {
        let review = Review(
            album_id: album!.id,
            title: title,
            rating: rating,
            description: description
        )
        
        do {
            try user.createReview(review: review)
        } catch {
            print(error)
        }
    }
    
    func selectAlbum(album: SearchResult) {
        if let album = album as? Album {
            self.album = album
        }
        tab = .edit
    }
    
    // MARK: Tabs
    
    enum ReviewTab {
        case search, edit
    }
}
