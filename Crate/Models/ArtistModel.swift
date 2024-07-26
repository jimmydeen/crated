import Foundation

class ArtistModel: NSObject, IdentifiableProtocol {
    let artist_name: String
    let artist_id: String
    let artist_image_url_high_quality: String?
    let artist_image_url_low_quality: String?
    
    init(artist_name: String, artist_id: String, artist_image_url_high_quality: String?, artist_image_url_low_quality: String?) {
        self.artist_name = artist_name
        self.artist_id = artist_id
        self.artist_image_url_high_quality = artist_image_url_high_quality
        self.artist_image_url_low_quality = artist_image_url_low_quality
    }
    
    var name: String { return artist_name }
    var id: String { return artist_id }
    var artists: [String]? { return nil }
    var image_url_high_quality: String? { return artist_image_url_high_quality }
    var image_url_low_quality: String? { return artist_image_url_low_quality }
}
