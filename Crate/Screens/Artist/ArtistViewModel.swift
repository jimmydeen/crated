import Foundation
import Observation

@Observable class ArtistViewModel {
    var artist: ArtistModel
    var albums: [AlbumModel] = []
    
    init(artist: ArtistModel) {
        self.artist = artist
    }
    
    @MainActor public func retrieveAlbums() async {
        do {
            let albums = try await SpotifyAPIService.fetchAlbumsByArtist(artistID: artist.id)
            self.albums = albums
        } catch {
            print(error)
        }
    }
}
