import Foundation

class AlbumModel: NSObject, IdentifiableProtocol {
    let album_name: String
    let album_artists: [String]
    let album_id: String
    let album_type: String
    let album_release_date: String
    let album_image_url_high_quality: String?
    let album_image_url_low_quality: String?
    
    init(album_name: String, album_artists: [String], album_id: String, album_type: String, album_release_date: String, album_image_url_high_quality: String?, album_image_url_low_quality: String?) {
        self.album_name = album_name
        self.album_artists = album_artists
        self.album_id = album_id
        self.album_type = album_type
        self.album_release_date = album_release_date
        self.album_image_url_high_quality = album_image_url_high_quality
        self.album_image_url_low_quality = album_image_url_low_quality
    }
    
    var name: String { return album_name }
    var id: String { return album_id }
    var artists: [String]? { return album_artists }
    var image_cover_url_high_quality: String? { return album_image_url_high_quality }
    var image_cover_url_low_quality: String? { return album_image_url_low_quality }
}
