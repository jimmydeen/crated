import Foundation

class ReviewModel: NSObject {
    let review_id: String = UUID().uuidString
    let album_id: String
    let user_id: String
    let review_rating: Double
    let review_description: String?
    
    init(album_id: String, user_id: String, review_rating: Double, review_description: String?) {
        self.album_id = album_id
        self.user_id = user_id
        self.review_rating = review_rating
        self.review_description = review_description
    }
}
