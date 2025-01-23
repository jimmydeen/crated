import Foundation
import SwiftUI

struct ReviewModel: SearchResult {
    let album_id: String
    let id: String
    let type: ReviewType
    let title: String
    let rating: Double?
    let description: String?
    let cover_hq: URL?
    let cover_lq: URL?
    
    var name: String { return title }
    var subtitle: String {
        if let subtitle = description {
            return subtitle
        } else {
            return ""
        }
    }
    
    init(
        album_id: String,
        id: String = UUID().uuidString,
        type: ReviewType,
        title: String,
        rating: Double?,
        description: String?,
        cover_hq: URL? = nil,
        cover_lq: URL? = nil
    ) {
        self.album_id = album_id
        self.id = id
        self.type = type
        self.title = title
        self.rating = rating
        self.description = description
        self.cover_hq = cover_hq
        self.cover_lq = cover_lq
    }
    
    func searchView() -> AnyView {
        AnyView(ReviewView(review: self))
    }
    
    enum ReviewType: String {
        case rating, review
    }
}
