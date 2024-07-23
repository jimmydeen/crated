import Foundation
import UIKit
import SwiftUI
import Combine
import Observation

@Observable class AlbumContextViewModel {
    var cover: UIImage?
    var gradient: Gradient?
    
    let album: AlbumModel
    
    private let gradientOpacity: CGFloat = 0.25
    private var cancellable: AnyCancellable?
    
    init(album: AlbumModel, cover: UIImage? = nil) {
        self.album = album
        self.cover = cover
    }

    @MainActor
    public func fetchCover() async {
        guard let urlString = album.album_image_url_hq,
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
    public func fetchGradient() {
        guard let colors = cover!.getColors() else {
            return
        }
        let primary = Color(colors.primary).opacity(gradientOpacity)
        let background = Color(colors.background).opacity(gradientOpacity)
        
        var gradientList = ColorUtilities.sortColorsByBrightness([primary, background])
        gradientList.append(.clear)
        
        gradient = Gradient(colors: gradientList)
    }
}
