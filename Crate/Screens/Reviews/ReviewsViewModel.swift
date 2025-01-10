import Foundation
import Observation

@Observable class ReviewsViewModel {
    var reviews: [AlbumModel: Double] = [:]
    
    let userViewModel: UserViewModel
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    
    public func fetchReviews() async {
        do {
            if let ratings = userViewModel.currentUser?.album_ratings {
                for albumID in ratings.keys {
                    let album = try await MusicMetadataAPIService.fetchAlbumDetails(albumID: albumID)
                    reviews[album] = ratings[albumID]
                }
            }
        } catch {
            print(error)
        }
    }
}
