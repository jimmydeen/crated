import SwiftUI

struct HomeAlbumContextView: View {
    @State var showingGradient: Bool = false
    @Binding var viewModel: AlbumViewModel

    private let albumDetailsOffsetNudgeVertical: CGFloat = 4
    private let albumTypePaddingNudgeLeading: CGFloat = 2
    private let cardCornerRadius: CGFloat = 8
    private let cardElementSpacing: CGFloat = 0
    private let cardPaddingInternal: CGFloat = 30
    private let cardPaddingTop: CGFloat = UIScreen.main.bounds.height * 0.05
    private let coverCornerRadius: CGFloat = 4
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let gradientAnimationDuration: CGFloat = 1.2
    private let gradientHeight: CGFloat = 250
    private let imagePaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.015
    private let internalPadding: CGFloat = 8
    private let shadowRadius: CGFloat = 12
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                ZStack {
                    if showingGradient {
                        LinearGradient(
                            gradient: viewModel.gradient!,
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                }
                .animation(
                    .easeOut(duration: gradientAnimationDuration),
                    value: showingGradient
                )

                VStack(spacing: imagePaddingBottom) {
                    Image(uiImage: viewModel.cover!)
                        .resizable()
                        .frame(width: coverSize, height: coverSize)
                        .shadow(radius: shadowRadius)

                    VStack(alignment: .leading, spacing: cardElementSpacing) {
                        HStack {
                            Text(viewModel.album.album_type.uppercased())
                                .padding(albumTypePaddingNudgeLeading)
                            
                            Spacer()
                            
                            Text(viewModel.album.album_release_date)
                        }
                        .font(.caption2)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .offset(y: albumDetailsOffsetNudgeVertical)
                        
                        Text(viewModel.album.album_name)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, internalPadding)
                }
                .frame(width: coverSize)
                .padding(cardPaddingInternal)
                .background(
                    RoundedRectangle(cornerRadius: cardCornerRadius)
                        .fill(.white)
                        .shadow(radius: shadowRadius)
                )
                .padding(.top, cardPaddingTop)
            }
            
            Spacer()
        }
        .onAppear {
            Task {
                viewModel.fetchGradient()
                showingGradient = true
            }
        }
    }
}
