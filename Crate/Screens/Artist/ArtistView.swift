import SwiftUI
import Kingfisher

struct ArtistView: View {
    @State var viewModel: ArtistViewModel
    
    private let coverPaddingBottom: CGFloat = 48
    private let coverSize: CGFloat = UIScreen.main.bounds.width
    private let gridRowCellCount: Int = 3
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.034
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    KFImage(viewModel.artist.cover_hq)
                        .resizable()
                        .frame(width: coverSize, height: coverSize)
                        .padding(.bottom, coverPaddingBottom)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), alignment: .leading), count: gridRowCellCount),
                        spacing: gridSpacing
                    ) {
                        ForEach(viewModel.albums, id: \.id) { album in
                            NavigationLink(
                                destination: AlbumView(viewModel: AlbumViewModel(album: album))
                            ) {
                                KFImage(album.cover_hq)
                                    .resizable()
                                    .frame(width: gridCellSize, height: gridCellSize)
                            }
                        }
                    }
                    .padding(.horizontal, gridSpacing)
                }
            }
            .navigationTitle(viewModel.artist.name.capitalized)
            .task {
                await viewModel.retrieveAlbums()
            }
        }
        .background(Color.white)
    }
    
    private var gridCellSize: CGFloat {
        let totalSpace = UIScreen.main.bounds.width - (gridSpacing * (CGFloat(gridRowCellCount) + 1))
        let cellSize = totalSpace / CGFloat(gridRowCellCount)
        return cellSize
    }
}

struct ArtistViewPreview: PreviewProvider {
    static var previews: some View {
        ArtistView(viewModel: ArtistViewModel(artist: MockData.artist))
    }
}
