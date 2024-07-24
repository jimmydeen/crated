import Foundation

protocol IdentifiableProtocol {
    var name: String { get }
    var id: String { get }
    var artists: [String]? { get }
    var image_cover_url_high_quality: String? { get }
    var image_cover_url_low_quality: String? { get }
}
