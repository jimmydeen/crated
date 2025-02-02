import Foundation
import SwiftUI

struct Track: SearchResult {
    let name: String
    let id: String
    let artists: [String]
    let cover: URL?
    let album_id: String
    let index: Int
    
    var subtitle: String? {
        return artists.joined(separator: ", ")
    }
    
    func searchView() -> AnyView {
        return AnyView(AlbumView(viewModel: AlbumViewModel(track: self)))
    }
}
