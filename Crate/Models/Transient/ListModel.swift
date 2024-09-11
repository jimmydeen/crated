import Foundation

class ListModel: NSObject {
    let name: String
    let id: UUID
    let user_id: UUID
    let albums: [AlbumModel]
    let image: String?
    
    init(
        name: String,
        id: UUID,
        user_id: UUID,
        albums: [AlbumModel] = [],
        image: String?
    ) {
        self.name = name
        self.id = id
        self.user_id = user_id
        self.albums = albums
        self.image = image
    }
}
