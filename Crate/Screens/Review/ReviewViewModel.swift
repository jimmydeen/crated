import Foundation
import Observation

@Observable class ReviewViewModel {
    private let metadata: MetadataService = .shared
    
    private(set) var album: Album?
    private(set) var isFetched: Bool = false
    private(set) var review: Review
    
    init(review: Review) {
        self.review = review
    }
    
    init(review: Review, album: Album) {
        self.review = review
        self.album = album
        
        isFetched = true
    }
    
    func fetchAlbum() async {
        guard isFetched else { return }
        
        do {
            album = try await metadata.fetchAlbumDetails(albumID: review.album_id)
            isFetched = true
        } catch {
            print(error)
        }
    }
}
