import Foundation

class ArtistModel: NSObject, ResultProtocol {
    let name: String
    let id: String
    let artists: [String]
    let image_url_hq: String?
    let image_url_lq: String?
    
    init(name: String, id: String, artists: [String], image_url_hq: String?, image_url_lq: String?) {
        self.name = name
        self.id = id
        self.artists = artists
        self.image_url_hq = image_url_hq
        self.image_url_lq = image_url_lq
    }
}
