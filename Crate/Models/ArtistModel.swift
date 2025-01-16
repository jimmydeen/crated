import Foundation
import SwiftUI

struct ArtistModel: ResultProtocol, Hashable {
    let name: String
    let id: String
    let artists: [String]
    let cover_hq: URL?
    let cover_lq: URL?
    
    public func searchView() -> AnyView {
        return AnyView(ArtistView(artist: self))
    }
}
