import Foundation
import SwiftUI

struct ArtistModel: SearchResult, Hashable {
    let name: String
    let id: String
    let cover_hq: URL?
    let cover_lq: URL?
    
    var subtitle: String {
        return ""
    }
    
    func searchView() -> AnyView {
        return AnyView(ArtistView(artist: self))
    }
}
