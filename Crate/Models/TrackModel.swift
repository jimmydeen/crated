import Foundation

struct TrackModel: ResultProtocol {
    let name: String
    let id: String
    let artists: [String]
    let cover_hq: URL
    let cover_lq: URL
    let album_id: String
    let index: Int
}
