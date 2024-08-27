import SwiftUI
import Kingfisher

struct ArtistView: View {
    @State var viewModel: ArtistViewModel
    
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.034
    private let rowCellCount: Int = 2
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: gridSpacing) {
                    ZStack {
                        if let urlString = viewModel.artist.artist_image_url_high_quality,
                           let url = URL(string: urlString) {
                            KFImage(url)
                                .resizable()
                                .frame(
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.width
                                )
                        }
                        
                        LinearGradient(
                            colors: [.clear, .clear, .clear, .clear, .clear, .clear, .clear, .white],
                            startPoint: .topLeading,
                            endPoint: .bottomLeading
                        )
                    }
                    
                    HStack {
                        Text(viewModel.artist.artist_name)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Spacer()
                    }
                    .padding(.leading, gridSpacing * 1.5)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), alignment: .leading),
                            GridItem(.flexible(), alignment: .trailing)
                        ],
                        spacing: gridSpacing
                    ) {
                        ForEach(viewModel.albums, id: \.id) { album in
                            NavigationLink(
                                destination: {
                                    AlbumView(viewModel: AlbumViewModel(album: album))
                                },
                                label: {
                                    if let urlString = album.image_url_high_quality,
                                       let url = URL(string: urlString) {
                                        KFImage(url)
                                            .resizable()
                                            .placeholder {
                                                ImagePlaceholderView()
                                            }
                                    }
                                }
                            )
                            .frame(width: cellSize, height: cellSize)
                        }
                    }
                    .padding(.horizontal, gridSpacing)
                }
            }
            .onAppear {
                Task {
                    if viewModel.albums.isEmpty {
                        await viewModel.retrieveAlbums()
                    }
                }
            }
        }
    }
    
    private var cellSize: CGFloat {
        let totalSpace = UIScreen.main.bounds.width - (gridSpacing * (CGFloat(rowCellCount) + 1))
        let cellSize = totalSpace / CGFloat(rowCellCount)
        return cellSize
    }
}

struct ArtistViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
                      
        ArtistView(
            viewModel: ArtistViewModel(artist:
                ArtistModel(
                    artist_name: "Drake",
                    artist_id: "3TVXtAsR1Inumwj472S9r4",
                    artist_image_url_high_quality: "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9",
                    artist_image_url_low_quality: "https://i.scdn.co/image/ab676161000051744293385d324db8558179afd9"
                )
            )
        )
        .environment(userViewModel)
    }
}
