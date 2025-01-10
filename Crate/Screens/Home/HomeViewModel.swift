import UIKit
import SwiftUI
import Observation

@Observable class HomeViewModel {
    var albums: [AlbumModel] = []
    var gradient: Gradient = Gradient.init(colors: [])

    public func fetchNewReleases() async {
        do {
            let response = try await MusicMetadataAPIService.fetchNewReleases(
                range: albums.count..<albums.count+6
            )
            albums.append(contentsOf: response)
        } catch {
            print(error)
        }
    }
    public func fetchGradient(_ album: AlbumModel) async -> Gradient? {
        do {
            let (data, _) = try await URLSession.shared.data(from: album.cover_lq)
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
