import UIKit
import SwiftUI
import Observation

@Observable class HomeViewModel: UserViewModel {
    let metadata: MetadataService = .shared
    
    var albums: [AlbumModel] = []
    var gradient: Gradient?

    public func fetchNewReleases() async {
        do {
            let response = try await metadata.fetchNewReleases(
                range: albums.count..<albums.count + 6
            )
            albums.append(contentsOf: response)
        } catch {
            print(error)
        }
    }
    public func fetchGradient(album: AlbumModel) async {
        guard let cover = album.cover_lq else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: cover)
            if let image = UIImage(data: data),
               let colors = image.getColors() {
                var gradientColors: [Color] = []
                gradientColors.append(Color(colors.primary))
                gradientColors.append(Color(colors.background))
                gradientColors = gradientColors.sorted { ColorUtilities.luminance(of: $0) < ColorUtilities.luminance(of: $1) }
                gradientColors.append(.clear)
                
                gradient = Gradient(colors: gradientColors)
            }
        } catch {
            print(error)
        }
    }
}
