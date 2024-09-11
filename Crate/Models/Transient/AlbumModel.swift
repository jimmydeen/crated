import Foundation

class AlbumModel: NSObject, ResultProtocol {
    let name: String
    let id: String
    let artists: [String]
    let type: String
    let release_date: String
    let spotify_link: String
    let image_url_hq: String?
    let image_url_lq: String?
    
    init(
        name: String,
        id: String,
        artists: [String],
        type: String,
        release_date: String,
        spotify_link: String,
        image_url_hq: String? = nil,
        image_url_lq: String? = nil
    ) {
        self.name = name
        self.id = id
        self.artists = artists
        self.type = type
        self.release_date = release_date
        self.image_url_hq = image_url_hq
        self.image_url_lq = image_url_lq
        self.spotify_link = spotify_link
    }
}
