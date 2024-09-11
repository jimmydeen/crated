import Foundation

protocol ResultProtocol {
    var name: String { get }
    var id: String { get }
    var artists: [String] { get }
    var image_url_hq: String? { get }
    var image_url_lq: String? { get }
}
