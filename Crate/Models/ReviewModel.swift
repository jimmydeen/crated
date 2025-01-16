import Foundation

struct ReviewModel {
    let album: String
    let type: ReviewType
    let title: String?
    let rating: Double?
    let description: String?
    
    public enum ReviewType: String {
        case rating, review
    }
}
