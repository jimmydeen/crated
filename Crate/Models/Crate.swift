import Foundation
import SwiftUI

struct Crate: Codable, SearchResult {
    let name: String
    let user_id: String
    let cover: URL?
    let albums: [String]
    let id: String
    
    var subtitle: String? { nil }
    
    init(
        name: String,
        user_id: String,
        cover: URL? = nil,
        albums: [String] = [],
        id: String = UUID().uuidString
    ) {
        self.name = name
        self.user_id = user_id
        self.cover = cover
        self.albums = albums
        self.id = id
    }
    
    func searchView() -> AnyView {
        return AnyView(CrateView(viewModel: CrateViewModel(crate: self)))
    }
}
