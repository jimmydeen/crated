import SwiftUI
import Kingfisher

struct ImagePlaceholderView: View {
    var body: some View {
        Rectangle().fill(Colors.placeholderGray)
    }
}

struct HomeAlbumView: View {
    let album: AlbumModel
    
    var body: some View {
        NavigationLink(destination: AlbumView(viewModel: AlbumViewModel(album: album))) {
            if let urlString = album.album_cover_url_high_quality,
               let url = URL(string: urlString) {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        ImagePlaceholderView()
                    }
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
                        HomeAlbumView(album: album)
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
        @State var userViewModel = SharedUserViewModel()
                      
        HomeView()
            .environment(userViewModel)
    }
}
