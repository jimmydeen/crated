import Foundation
import Observation

@Observable class AlbumViewModel {
    private let metadata: MetadataService = .shared
    private let track: Track?
    private let user: UserService = .shared
    
    private(set) var album: Album?
    private(set) var favorites: Set<String> = []
    private(set) var isFavorite: Bool = false
    private(set) var isLoaded: Bool = false
    private(set) var rating: Double = 0
    private(set) var tracks: [Track] = []
    
    init(album: Album) {
        self.album = album
        self.track = nil
        self.isLoaded = true
    }
    
    init(track: Track) {
        self.album = nil
        self.track = track
    }

    func fetchAlbum() async {
        do {
            album = try await metadata.fetchAlbumDetails(albumID: track!.album_id)
            isLoaded = true
        } catch {
            print(error)
        }
    }
    
    func fetchTracks() async {
        guard tracks.isEmpty else { return }
        
        do {
            tracks = try await metadata.fetchTracks(album: album!)
        } catch {
            print(error)
        }
    }
    
    func fetchInfo() async {
        do {
            favorites = Set(try await user.retrieveAlbumFavorites(album_id: album!.id))
            isFavorite = try await user.isAlbumFavorited(album: album!)
            rating = try await user.retrieveRating(album_id: album!.id)
        } catch {
            print(error)
        }
    }
    
    func favoriteAlbum() {
        isFavorite.toggle()
        
        Task {
            do {
                try await user.favoriteAlbum(album: album!)
            } catch {
                print(error)
            }
        }
    }
    
    func favoriteTrack(track: Track) {
        if favorites.contains(track.id) {
            favorites.remove(track.id)
        } else {
            favorites.insert(track.id)
        }
        
        Task {
            do {
                try await user.favoriteTrack(track: track)
            } catch {
                print(error)
            }
        }
    }
    
    func rateAlbum(rating: Double) async {
        do {
            if self.rating == rating {
                self.rating = 0
            } else {
                self.rating = rating
            }
            try await user.updateRating(id: album!.id, rating: rating)
        } catch {
            print(error)
        }
    }
}
