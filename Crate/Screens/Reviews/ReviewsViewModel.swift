import Foundation
import Observation

@Observable class ReviewsViewModel {
    private let metadata: MetadataService = .shared
    private let user: UserService = .shared
    
    private(set) var reviews: [Review] = []
    
    func fetchReviews() async {
        do {
            reviews = try await user.retrieveReviews()
        } catch {
            print(error)
        }
    }
}
