import Foundation

class ListModel: NSObject {
    let name: String
    let user_id: UUID
    let image: URL
    let albums: [AlbumModel]
    let id: UUID
    
    init(
        name: String,
        user_id: UUID,
        image: URL,
        albums: [AlbumModel] = [],
        id: UUID = UUID()
    ) {
        self.name = name
        self.user_id = user_id
        self.image = image
        self.albums = albums
        self.id = id
    }
}
