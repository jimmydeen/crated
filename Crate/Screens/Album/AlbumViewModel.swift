import Foundation
import Observation

@Observable class AlbumViewModel: UserViewModel {
    let metadata: MetadataService = .shared
    
    var album: AlbumModel?
    var favorites: [String] = []
    var isFavorite: Bool = false
    var isLoaded: Bool = false
    var rating: Double = 0
    var track: TrackModel?
    var tracks: [TrackModel] = []
    
    init(album: AlbumModel) {
        self.album = album
        self.track = nil
        self.isLoaded = true
    }
    
    init(track: TrackModel) {
        self.album = nil
        self.track = track
    }

    public func fetchAlbum() async {
        do {
            album = try await metadata.fetchAlbumDetails(albumID: track!.album_id)
            isLoaded = true
        } catch {
            print(error)
        }
    }
    public func fetchInfo() async {
        guard tracks.isEmpty else { return }
        
        do {
            tracks = try await metadata.fetchTracks(album: album!)
            favorites = try await user.retrieveAlbumFavorites(album: album!)
            isFavorite = try await user.isAlbumFavorited(album: album!)
            rating = try await user.retrieveRating(album: album!)
        } catch {
            print(error)
        }
    }
    
    public func favoriteAlbum() async {
        do {
            if isFavorite {
                try await user.unfavoriteAlbum(album: album!)
            } else {
                try await user.favoriteAlbum(album: album!)
            }
        } catch {
            print(error)
        }
        isFavorite.toggle()
    }
    
    public func favoriteTrack(track: TrackModel) async {
        do {
            if try await user.isTrackFavorited(track: track) {
                try await user.unfavoriteTrack(track: track)
            } else {
                try await user.favoriteTrack(track: track)
            }
        } catch {
            print(error)
        }
    }
    
    public func rateAlbum(rating: Double) async {
        if self.rating == rating {
            self.rating = 0
            do {
                try await user.updateRating(id: album!.id, rating: 0)
            } catch {
                print(error)
            }
        } else {
            self.rating = rating
            do {
                try await user.updateRating(id: album!.id, rating: rating)
            } catch {
                print(error)
            }
        }
    }
}
