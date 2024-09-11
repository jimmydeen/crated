import Foundation
import UIKit
import SwiftUI
import Observation
import CoreData

@Observable class AlbumViewModel {
    var cover: UIImage?
    var gradient: Gradient?
    var tracks: [TrackModel] = []
    
    let album: AlbumModel
    
    private let gradientOpacity: CGFloat = 0.25
    
    init(album: AlbumModel, cover: UIImage? = nil) {
        self.album = album
        self.cover = cover
    }

    @MainActor public func fetchCover() async {
        guard let urlString = self.album.image_url_hq,
            let url = URL(string: urlString) else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                self.cover = image
            }
        } catch {
            print("Failed to fetch cover image: \(error)")
        }
    }
    @MainActor public func fetchTracks() async {
        do {
            if tracks.isEmpty {
                let tracks = try await SpotifyAPIService.retrieveTracks(for: self.album)
                self.tracks.append(contentsOf: tracks)
            }
        } catch {
            print(error)
        }
    }
    
    public func fetchGradient() {
        if let cover = self.cover,
           let colors = cover.getColors() {
            var gradientColors: [Color] = []
            gradientColors.append(Color(colors.primary).opacity(gradientOpacity))
            gradientColors.append(Color(colors.background).opacity(gradientOpacity))
            gradientColors = gradientColors.sorted { ColorUtilities.luminance(of: $0) < ColorUtilities.luminance(of: $1) }
            gradientColors.append(.clear)
            
            self.gradient = Gradient(colors: gradientColors)
        }
    }
}
