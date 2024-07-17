import Foundation

class ArtistModel: NSObject, IdentifiableProtocol {
    let artist_name: String
    let artist_id: String
    let artist_image_url_hq: String?
    let artist_image_url_lq: String?
    
    init(artist_name: String, artist_id: String, artist_image_url_hq: String?, artist_image_url_lq: String?) {
        self.artist_name = artist_name
        self.artist_id = artist_id
        self.artist_image_url_hq = artist_image_url_hq
        self.artist_image_url_lq = artist_image_url_lq
    }
    
    var name: String { return artist_name }
    var id: String { return artist_id }
    var artists: [String]? { return nil }
    var image_cover_url_hq: String? { return artist_image_url_hq }
    var image_cover_url_lq: String? { return artist_image_url_lq }
}
