import SwiftUI

struct ArtistView: View {
    let artist: ArtistModel
    
    var body: some View {
        VStack {
            if let urlString = artist.artist_image_url_high_quality,
               let url = URL(string: urlString) {
                AsyncImageView(for: url)
            }
        }
    }
}

struct ArtistViewPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
