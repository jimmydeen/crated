import Foundation
import SwiftUI

protocol SearchResult {
    var id: String { get }
    var name: String { get }
    var cover: URL? { get }
    var subtitle: String? { get }
    
    func searchView() -> AnyView
}
