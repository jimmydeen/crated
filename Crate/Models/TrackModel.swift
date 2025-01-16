import Foundation
import SwiftUI

struct TrackModel: ResultProtocol, Hashable {
    let name: String
    let id: String
    let artists: [String]
    let cover_hq: URL?
    let cover_lq: URL?
    let album_id: String
    let index: Int
    
    public func searchView() -> AnyView {
        return AnyView(AlbumView(track: self))
    }
}
