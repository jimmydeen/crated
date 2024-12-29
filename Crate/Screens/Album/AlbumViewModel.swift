import Foundation
import UIKit
import SwiftUI
import Observation
import CoreData

@Observable class AlbumViewModel {
    var tracks: [TrackModel] = []
    
    let album: AlbumModel
    
    init(album: AlbumModel) {
        self.album = album
    }

    public func fetchTracks() async {
        do {
            let tracks = try await SpotifyAPIService.fetchTracks(album: self.album)
            self.tracks.append(contentsOf: tracks)
        } catch {
            print(error)
        }
    }
}
