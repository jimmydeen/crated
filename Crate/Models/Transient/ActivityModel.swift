import Foundation

class ActivityModel: NSObject {
    let id: UUID
    let username: String
    let date: Date
    let type: ActivityType
    let album: AlbumModel?
    let rating: Double?
    
    init(
        id: UUID = UUID(),
        username: String,
        date: Date,
        type: ActivityType,
        album: AlbumModel? = nil,
        rating: Double? = nil
    ) {
        self.id = id
        self.username = username
        self.date = date
        self.type = type
        self.album = album
        self.rating = rating
    }
}
