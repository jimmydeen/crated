import Foundation

class TrackModel: NSObject, IdentifiableProtocol {
    let track_name: String
    let album_id: String
    let track_id: String
    let track_index: Int
    let track_artists: [String]
    let track_image_url_high_quality: String?
    let track_image_url_low_quality: String?
    
    init(album_id: String, track_id: String, track_name: String, track_index: Int, track_artists: [String], track_image_url_high_quality: String?, track_image_url_low_quality: String?) {
        self.track_name = track_name
        self.album_id = album_id
        self.track_id = track_id
        self.track_index = track_index
        self.track_artists = track_artists
        self.track_image_url_high_quality = track_image_url_high_quality
        self.track_image_url_low_quality = track_image_url_low_quality
    }
    
    var name: String { return track_name }
    var id: String { return track_id }
    var artists: [String]? { return track_artists }
    var image_url_high_quality: String? { return track_image_url_high_quality }
    var image_url_low_quality: String? { return track_image_url_low_quality }
}
