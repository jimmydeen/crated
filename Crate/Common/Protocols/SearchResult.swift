import Foundation
import SwiftUI

protocol SearchResult {
    var id: String { get }
    var name: String { get }
    var cover_hq: URL? { get }
    var cover_lq: URL? { get }
    var subtitle: String { get }
    
    func searchView() -> AnyView
}
