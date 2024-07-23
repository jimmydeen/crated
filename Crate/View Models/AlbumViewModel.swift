import Foundation
import Observation

@Observable class AlbumViewModel {
    var tracks: [TrackModel] = []

    let album: AlbumModel

    init(album: AlbumModel) {
        self.album = album
    }

    @MainActor
    public func fetchTracks() async {
        let tracks = await SpotifyAPIService.retrieveTracks(for: self.album)
        self.tracks.append(contentsOf: tracks)
    }
}
