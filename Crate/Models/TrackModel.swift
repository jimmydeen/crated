import Foundation
import SwiftUI

struct TrackModel: SearchResult, Hashable {
    let name: String
    let id: String
    let artists: [String]
    let cover_hq: URL?
    let cover_lq: URL?
    let album_id: String
    let index: Int
    
    var subtitle: String {
        return artists.joined(separator: ", ")
    }
    
    func searchView() -> AnyView {
        return AnyView(AlbumView(track: self))
    }
}
