import Foundation
import Combine
import SwiftUI

class AlbumInfoViewModel: ObservableObject {
    @Published var tracks: [TrackModel] = []

    let album: AlbumModel

    private let gradientOpacity: CGFloat = 0.25
    private var cancellables = Set<AnyCancellable>()

    init(album: AlbumModel) {
        self.album = album

        Task.detached {
            await self.fetchTracks()
        }
    }

    public func fetchTracks() async {
        let tracks = await SpotifyAPIService.retrieveTracks(for: self.album)
        await MainActor.run {
            self.tracks.append(contentsOf: tracks)
        }
    }

    public func loadGradientColors(completion: @escaping ([Color]) -> Void) async {
        DispatchQueue.global(qos: .background).async {
            let colors = self.fetchGradient()
            DispatchQueue.main.async {
                completion(colors)
            }
        }
    }

    public func fetchGradient() -> [Color] {
        guard let image_url = album.album_image_url_lq else {
            return [Color.white]
        }
        guard let data = try? Data(contentsOf: URL(string: image_url)!) else {
            return [Color.white]
        }
        guard let image = UIImage(data: data) else {
            return [Color.white]
        }
        guard let colors = image.getColors() else {
            return [Color.white]
        }

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
