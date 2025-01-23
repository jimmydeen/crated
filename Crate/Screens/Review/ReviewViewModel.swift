import Foundation
import Observation

@Observable class ReviewViewModel {
    private let metadata: MetadataService = .shared
    
    var album: AlbumModel?
    var needToFetchAlbum: Bool = true
    var review: ReviewModel
    
    init(review: ReviewModel) {
        self.review = review
    }
    
    init(review: ReviewModel, album: AlbumModel) {
        self.review = review
        self.album = album
        
        needToFetchAlbum = false
    }
    
    func fetchAlbum() async {
        do {
            album = try await metadata.fetchAlbumDetails(albumID: review.album_id)
        } catch {
            print(error)
        }
    }
}
