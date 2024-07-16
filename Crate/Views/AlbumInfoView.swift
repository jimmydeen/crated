import SwiftUI

struct AlbumInfoView: View {
    @ObservedObject var albumInfoViewModel: AlbumInfoViewModel
    
    private var coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private var gradientBoxHeight: CGFloat = UIScreen.main.bounds.height * 0.3
    private var imagePaddingTop: CGFloat = UIScreen.main.bounds.height * 0.03
    
    init(album: AlbumModel) {
        self.albumInfoViewModel = AlbumInfoViewModel(album: album)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: albumInfoViewModel.generateGradientList()),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                .frame(height: 250)
                Spacer()
            }
            
            VStack {
                AsyncImage(url: URL(string: albumInfoViewModel.album.album_image_url_hq)) { phase in
                    if (phase.image != nil) {
                        phase.image!
                            .resizable()
                            .frame(width: coverSize, height: coverSize)
                    }
                }
                .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
                .padding(.top, imagePaddingTop)
                .padding(.bottom, imagePaddingTop / 2)
            }
        }
    }
}
