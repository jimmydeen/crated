import Foundation
import SwiftUI

struct Artist: Identifiable, SearchResult {
    let name: String
    let id: String
    let cover_hq: URL?
    let cover_lq: URL?
    
    var cover: URL? {
        return cover_lq
    }
    
    var subtitle: String? { nil }
    
    func searchView() -> AnyView {
        return AnyView(ArtistView(viewModel: ArtistViewModel(artist: self)))
    }
}
