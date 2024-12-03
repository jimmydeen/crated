import Foundation
import UIKit
import SwiftUI
import Observation

@Observable class HomeViewModel {
    var albums: [AlbumModel] = []
    var gradient: Gradient = Gradient.init(colors: [])

    public func fetchNewReleases() async {
        do {
            let response = try await SpotifyAPIService.retrieveLatestAlbums(
                from: albums.count,
                to: albums.count + 6
            )
            self.albums.append(contentsOf: response)
        } catch {
            print(error)
        }
    }
    public func fetchGradient(_ album: AlbumModel) async -> Gradient? {
        guard let urlString = album.image_url_hq,
            let url = URL(string: urlString) else {
            return nil
            }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data),
               let colors = image.getColors() {
                var gradientColors: [Color] = []
                gradientColors.append(Color(colors.primary))
                gradientColors.append(Color(colors.background))
                gradientColors = gradientColors.sorted { ColorUtilities.luminance(of: $0) < ColorUtilities.luminance(of: $1) }
                gradientColors.append(.clear)
                
                return Gradient(colors: gradientColors)
            }
        } catch {
            print("There was an error fetching the image gradient: \(error)")
        }
        return nil
    }
}
