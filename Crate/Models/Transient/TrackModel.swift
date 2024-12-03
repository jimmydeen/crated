import Foundation

class TrackModel: NSObject, ResultProtocol {
    let name: String
    let album_id: String
    let id: String
    let index: Int
    let artists: [String]
    let image_url_hq: String?
    let image_url_lq: String?
    
    init(
        name: String,
        album_id: String,
        id: String,
        index: Int,
        artists: [String],
        image_url_hq: String?,
        image_url_lq: String?
    ) {
        self.name = name
        self.album_id = album_id
        self.id = id
        self.index = index
        self.artists = artists
        self.image_url_hq = image_url_hq
        self.image_url_lq = image_url_lq
    }
}
