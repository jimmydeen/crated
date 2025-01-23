import Foundation
import SwiftUI

struct ListModel: SearchResult {
    let name: String
    let user_id: String
    let cover_hq: URL?
    let cover_lq: URL?
    let albums: [String]
    let id: String
    
    var subtitle: String {
        return ""
    }
    
    func searchView() -> AnyView {
        return AnyView(ListView(list: self))
    }
}
