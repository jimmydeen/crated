import Foundation
import SwiftUI

protocol ResultProtocol: Hashable {
    var id: String { get }
    var name: String { get }
    var artists: [String] { get }
    var cover_hq: URL { get }
    var cover_lq: URL { get }
}
