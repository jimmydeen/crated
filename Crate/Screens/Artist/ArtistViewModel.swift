import Foundation
import Observation

@Observable class ArtistViewModel {
    var artist: ArtistModel
    var albums: [AlbumModel] = []
    
    init(artist: ArtistModel) {
        self.artist = artist
    }
    
    public func retrieveAlbums() async {
        guard albums.isEmpty else { return }
        do {
            let newAlbums = try await MusicMetadataAPIService.fetchAlbumsByArtist(artistID: artist.id)
            self.albums = newAlbums
        } catch {
            print(error)
        }
    }
}
