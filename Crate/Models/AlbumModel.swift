import Foundation

class AlbumModel: NSObject, IdentifiableModel {
    let album_name: String
    let album_artists: [String]
    let album_id: String
    let album_type: String
    let album_release_date: String
    let album_image_url_hq: String
    let album_image_url_lq: String
    
    init(album_name: String, album_artists: [String], album_id: String, album_type: String, album_release_date: String, album_image_url_hq: String, album_image_url_lq: String) {
        self.album_name = album_name
        self.album_artists = album_artists
        self.album_id = album_id
        self.album_type = album_type
        self.album_release_date = album_release_date
        self.album_image_url_hq = album_image_url_hq
        self.album_image_url_lq = album_image_url_lq
    }
    
    var id: String {
        return album_id
    }
}
