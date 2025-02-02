import Foundation
import SwiftUI

struct Album: Hashable, Identifiable, SearchResult {
    let name: String
    let id: String
    let artists: [String]
    let cover_hq: URL?
    let cover_lq: URL?
    let type: AlbumType
    let date: Date
    let date_precision: DatePrecision
    let spotify_link: URL
    
    var cover: URL? {
        return cover_lq
    }
    
    var subtitle: String? {
        return artists.joined(separator: ", ")
    }
    
    func searchView() -> AnyView {
        return AnyView(AlbumView(viewModel: AlbumViewModel(album: self)))
    }
    
    enum AlbumType: String, Hashable {
        case album, single, compilation
    }
}
