import Foundation
import SwiftUI

class AlbumInfoViewModel: ObservableObject {
    @Published var tracks: [TrackModel] = []
    @Published var colors: UIImageColors = UIImageColors(background: .white, primary: .white, secondary: .white, detail: .white)
    
    let album: AlbumModel
    
    private let gradientOpacity: CGFloat = 0.75
    
    init(album: AlbumModel) {
        self.album = album
        self.colors = UIImageColors(background: .white, primary: .white, secondary: .white, detail: .white)
        
        Task.detached {
            await self.fetchColors()
            await self.fetchTracks()
        }
    }
    
    public func fetchColors() async {
        guard let url = URL(string: album.album_image_url_lq!),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data),
              let fetchedColors = image.getColors() else {
            return
        }
        
        await MainActor.run {
            self.colors = fetchedColors
        }
    }
    public func fetchTracks() async {
        let tracks = await SpotifyAPIService.retrieveTracks(for: self.album)
        await MainActor.run {
            self.tracks.append(contentsOf: tracks)
        }
    }
    public func generateGradientList() -> [Color] {
        var gradientColors: [Color] = []
        let primary = Color(colors.primary).opacity(gradientOpacity)
        let background = Color(colors.background).opacity(gradientOpacity)
        
        if primary != Color.white { gradientColors.append(primary) }
        if background != Color.white { gradientColors.append(background) }
        
        gradientColors = ColorUtilities.sortColorsByBrightness(gradientColors)
        gradientColors.append(Color.clear)
        return gradientColors
    }
}
