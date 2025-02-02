import Foundation
import Observation

@Observable class ArtistViewModel {
    private let metadata: MetadataService = .shared
    
    private(set) var artist: Artist
    private(set) var albums: [Album] = []
    private(set) var compilations: [Album] = []
    private(set) var singles: [Album] = []
    
    init(artist: Artist) {
        self.artist = artist
    }
    
    func retrieveAlbums() async {
        do {
            let albums = try await metadata.fetchAlbumsByArtist(artistID: artist.id)
            for album in albums {
                switch album.type {
                    case .album: self.albums.append(album)
                    case .compilation: self.compilations.append(album)
                    case .single: self.singles.append(album)
                }
            }
        } catch {
            print(error)
        }
    }
}
