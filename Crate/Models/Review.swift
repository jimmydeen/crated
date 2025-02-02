import Foundation
import SwiftUI

struct Review: Codable, SearchResult {
    let album_id: String
    let id: String
    let title: String?
    let rating: Double?
    let description: String?
    let cover: URL?
    
    var name: String {
        return title ?? ""
    }
    
    var subtitle: String? {
        if let subtitle = description {
            return subtitle
        } else {
            return nil
        }
    }
    
    init(
        album_id: String,
        id: String = UUID().uuidString,
        title: String? = nil,
        rating: Double? = nil,
        description: String? = nil,
        cover: URL? = nil
    ) {
        self.album_id = album_id
        self.id = id
        self.title = title
        self.rating = rating
        self.description = description
        self.cover = cover
    }
    
    func searchView() -> AnyView {
        AnyView(ReviewView(viewModel: ReviewViewModel(review: self)))
    }
}
