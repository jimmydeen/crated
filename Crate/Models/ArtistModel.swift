import Foundation

struct ArtistModel: ResultProtocol {
    let name: String
    let id: String
    let artists: [String]
    let cover_hq: URL
    let cover_lq: URL
}
