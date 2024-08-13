import SwiftUI

struct HomeAlbumView: View {
    @State var viewModel: AlbumViewModel
    
    var body: some View {
        NavigationLink(destination: AlbumView(viewModel: $viewModel)) {
            ZStack {
                Rectangle().fill(Colors.placeholderGray)
                
                if let cover = viewModel.cover {
                    Image(uiImage: cover)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCover()
            }
        }
    }
}

struct HomeView: View {
    @State var viewModel: HomeViewModel = HomeViewModel()
    
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.028
    private let rowCellCount: Int = 3
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: rowCellCount
                    ),
                    spacing: gridSpacing)
                {
                    ForEach(viewModel.albums, id: \.id) { album in
                        HomeAlbumView(viewModel: AlbumViewModel(album: album))
                            .frame(width: cellSize, height: cellSize)
                            .onAppear {
                                if album.id == viewModel.albums.last?.id {
                                    Task {
                                        await viewModel.fetchAlbums()
                                    }
                                }
                            }
                    }
                }
                .padding(.horizontal, gridSpacing)
            }
            .navigationTitle("New Releases")
        }
        .onAppear {
            Task {
                await viewModel.fetchAlbums()
            }
        }
    }
    
    private var cellSize: CGFloat {
        let totalSpace = UIScreen.main.bounds.width - (gridSpacing * (CGFloat(rowCellCount) + 1))
        let cellSize = totalSpace / CGFloat(rowCellCount)
        return cellSize
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
