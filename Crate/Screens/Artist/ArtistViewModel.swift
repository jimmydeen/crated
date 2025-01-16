import Foundation
import Observation

@Observable class ArtistViewModel {
    let metadata: MetadataService = .shared
    var artist: ArtistModel
    var albums: [AlbumModel] = []
    
    init(artist: ArtistModel) {
        self.artist = artist
    }
    
    public func retrieveAlbums() async {
        albums.removeAll()
        
        do {
            let newAlbums = try await metadata.fetchAlbumsByArtist(artistID: artist.id)
            self.albums = newAlbums
        } catch {
            print(error)
        }
    }
}
