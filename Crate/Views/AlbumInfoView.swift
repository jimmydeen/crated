import SwiftUI

struct AlbumInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var albumInfoViewModel: AlbumInfoViewModel
    @State private var isVisible: Bool = false
    @State private var gradientColors: [Color] = [.clear, .clear]

    private var albumDetailsOffsetNudgeVertical: CGFloat = 4
    private var albumTypePaddingNudgeLeading: CGFloat = 2
    private var cardCornerRadius: CGFloat = 8
    private var cardPaddingTop: CGFloat = UIScreen.main.bounds.height * 0.05
    private var cardPaddingInternal: CGFloat = 30
    private var coverCornerRadius: CGFloat = 4
    private var coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private var gradientHeight: CGFloat = 250
    private var imagePaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.015
    private var internalPadding: CGFloat = 8
    private var verticalElementSpacing: CGFloat = 0

    init(album: AlbumModel) {
        self.albumInfoViewModel = AlbumInfoViewModel(album: album)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                ZStack {
                    if isVisible {
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topTrailing,
                            endPoint: .center
                        )
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    }
                }
                .transition(.move(edge: .top))
                .ignoresSafeArea(.all)
                .animation(.easeOut(duration: 1.2).delay(2.0), value: isVisible)

                VStack(spacing: verticalElementSpacing) {
                    AsyncImage(url: URL(string: albumInfoViewModel.album.album_image_url_hq!)) { phase in
                        if phase.image != nil {
                            phase.image!
                                .resizable()
                                .frame(height: coverSize)
                                .clipShape(RoundedRectangle(cornerRadius: coverCornerRadius))
                        } else {
                            RoundedRectangle(cornerRadius: coverCornerRadius)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: coverSize)
                        }
                    }
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.bottom, imagePaddingBottom)

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(albumInfoViewModel.album.album_type.uppercased())
                                .padding(albumTypePaddingNudgeLeading)
                            Spacer()
                            Text(albumInfoViewModel.album.album_release_date)
                        }
                        .font(.caption2)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .offset(y: albumDetailsOffsetNudgeVertical)

                        Text(albumInfoViewModel.album.album_name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .lineSpacing(0)
                    }
                    .padding(.horizontal, internalPadding)
                }
                .frame(width: coverSize)
                .padding(cardPaddingInternal)
                .background(
                    RoundedRectangle(cornerRadius: cardCornerRadius)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.top, cardPaddingTop)
            }

            Spacer()
        }
        .onAppear {
            Task {
                await albumInfoViewModel.loadGradientColors { colors in
                    gradientColors = colors
                }
            }
            isVisible = true
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.blue)
        })
    }
}

struct AlbumInfoViewPreview: PreviewProvider {
    static var previews: some View {
        AlbumInfoView(
            album: AlbumModel(
                album_name: "More Life",
                album_artists: ["Drake"],
                album_id: "1lXY618HWkwYKJWBRYR4MK",
                album_type: "album",
                album_release_date: "2017-03-18",
                album_image_url_hq: "https://i.scdn.co/image/ab67616d0000b2734f0fd9dad63977146e685700",
                album_image_url_lq: "https://i.scdn.co/image/ab67616d00001e024f0fd9dad63977146e685700"
            )
        )
    }
}

/**
    Example Album Information it is changed:
 
    MORE LIFE by DRAKE
    - album_name: "More Life",
    - album_artists: ["Drake"],
    - album_id: "1lXY618HWkwYKJWBRYR4MK",
    - album_type: "album",
    - album_release_date: "2017-03-18",
    - album_image_url_hq: "https://i.scdn.co/image/ab67616d0000b2734f0fd9dad63977146e685700",
    - album_image_url_lq: "https://i.scdn.co/image/ab67616d00001e024f0fd9dad63977146e685700"
 */
