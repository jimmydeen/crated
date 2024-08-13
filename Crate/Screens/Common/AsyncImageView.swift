import SwiftUI

struct AsyncImageView: View {
    let imageURL: URL
    
    init(for url: URL) {
        self.imageURL = url
    }
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                case .failure, .empty:
                    Rectangle().fill(Colors.placeholderGray)
                @unknown default:
                    Rectangle().fill(Colors.placeholderGray)
            }
        }
    }
}
