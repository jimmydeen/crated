import Foundation

protocol IdentifiableProtocol {
    var name: String { get }
    var id: String { get }
    var artists: [String]? { get }
    var image_cover_url_hq: String? { get }
    var image_cover_url_lq: String? { get }
}
