import SwiftUI
import Kingfisher

struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel
    
    private let gridRowCellCount: Int = 3
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.034
    
    var body: some View {
        VStack {
            if !viewModel.favorites.isEmpty {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), alignment: .leading), count: gridRowCellCount),
                    spacing: gridSpacing
                ) {
                    ForEach(viewModel.favorites, id: \.id) { album in
                        NavigationLink(
                            destination: AlbumView(viewModel: AlbumViewModel(album: album))
                        ) {
                            KFImage(album.cover_hq)
                                .resizable()
                                .frame(width: gridCellSize, height: gridCellSize)
                        }
                    }
                }
            } else {
                VStack {
                    Text("No favorites just yet.")
                }
            }
        }
        .navigationTitle("Favorites")
        .task {
            await viewModel.fetchFavorites()
        }
    }
    
    private var gridCellSize: CGFloat {
        let totalSpace = UIScreen.main.bounds.width - (gridSpacing * (CGFloat(gridRowCellCount) + 1))
        let cellSize = totalSpace / CGFloat(gridRowCellCount)
        return cellSize
    }
}
