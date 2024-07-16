import Foundation

class TrackModel: NSObject, IdentifiableModel {
    let track_name: String
    let album_id: String
    let track_id: String
    let track_index: Int
    let track_artists: [String]
    let track_image_url_hq: String
    let track_image_url_lq: String
    
    init(album_id: String, track_id: String, track_name: String, track_index: Int, track_artists: [String], track_image_url_hq: String, track_image_url_lq: String) {
        self.track_name = track_name
        self.album_id = album_id
        self.track_id = track_id
        self.track_index = track_index
        self.track_artists = track_artists
        self.track_image_url_hq = track_image_url_hq
        self.track_image_url_lq = track_image_url_lq
    }
    
    var id: String {
        return track_id
    }
}
