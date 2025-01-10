import Foundation
import Observation

@Observable class AlbumViewModel {
    let album: AlbumModel
    
    var favorites: [String] = []
    var isFavorite: Bool = false
    var rating: Double = 0
    var tracks: [TrackModel] = []
    var user: UserModel
    
    private let databaseService: DataStoreService

    init(album: AlbumModel) {
        self.album = album
        self.databaseService = .shared
        self.user = MockData.user
        self.isFavorite = user.favorite_albums.contains(album.id)
        self.rating = user.album_ratings[album.id] ?? 0
    }

    public func fetchTracksInfo() async {
        do {
            let tracks = try await MusicMetadataAPIService.fetchTracks(album: album)
            favorites = user.favorite_tracks[album.id] ?? []
            self.tracks.append(contentsOf: tracks)
        } catch {
            print(error)
        }
    }
    public func updateUser() async { }
    
    public func favoriteAlbum() async {
        if isFavorite {
            if let index = user.favorite_albums.firstIndex(of: album.id) {
                user.favorite_albums.remove(at: index)
            }
        } else {
            if !user.favorite_albums.contains(album.id) {
                user.favorite_albums.append(album.id)
            }
        }
        isFavorite.toggle()
        
        await updateUser()
    }
    public func favoriteTrack(_ track: TrackModel) async {
        if user.favorite_tracks.keys.contains(album.id) {
            if user.favorite_tracks[album.id]!.contains(track.id) {
                if let index = user.favorite_tracks[album.id]!.firstIndex(of: track.id) {
                    user.favorite_tracks[album.id]!.remove(at: index)
                }
                if user.favorite_tracks[album.id]!.isEmpty {
                    user.favorite_tracks.removeValue(forKey: album.id)
                }
            } else {
                user.favorite_tracks[album.id]!.append(track.id)
            }
        } else {
            user.favorite_tracks[album.id] = [track.id]
        }
        
        await updateUser()
    }
    public func rateAlbum(_ newRating: Double) {
        if rating == newRating {
            rating = 0
            user.album_ratings[album.id] = 0
        } else {
            rating = newRating
            user.album_ratings[album.id] = rating
        }
        
        Task {
            await updateUser()
        }
    }
}
