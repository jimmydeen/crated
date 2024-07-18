import SwiftUI

struct HomeAlbumView: View {
    let album: AlbumModel
    
    var body: some View {
        NavigationLink(destination: AlbumInfoView(album: album)) {
            AsyncImage(url: URL(string: album.album_image_url_hq!)) { image in
                image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } placeholder: {
                
            }
        }
    }
}

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.02
    private let rowSize: Int = 3
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    HStack {
                        Text("Let's Discover")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.leading, gridSpacing)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.adaptive(minimum: 150)), count: rowSize),
                        spacing: gridSpacing)
                    {
                        ForEach(homeViewModel.albums.indices, id: \.self) { index in
                            let album = homeViewModel.albums[index]
                            
                            if index == homeViewModel.albums.count - rowSize {
                                HomeAlbumView(album: album)
                                    .onAppear {
                                        Task {
                                            await homeViewModel.addAlbums()
                                        }
                                    }
                                    .frame(width: cellSize, height: cellSize)
                            } else {
                                HomeAlbumView(album: album)
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                    .padding(.horizontal, gridSpacing)
                }
            }
        }
    }
    
    private var cellSize: CGFloat {
        let usedWidth = gridSpacing * (CGFloat(rowSize) + 2)
        let availableWidth = UIScreen.main.bounds.width - usedWidth
        return availableWidth / CGFloat(rowSize)
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
