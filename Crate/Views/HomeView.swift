import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    private let gridRowCount = 3
    private let gridSpacing = UIScreen.main.bounds.width * 0.02
    
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
                    .padding(.top, 20)
                    .padding(.leading, gridSpacing * 1.2)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 150)), count: 3), spacing: 10) {
                        ForEach(homeViewModel.albums.indices, id: \.self) { index in
                            let album = homeViewModel.albums[index]
                            
                            if index == homeViewModel.albums.count - 1 {
                                NavigationLink(destination: AlbumInfoView(album: album)) {
                                    AsyncImage(url: URL(string: album.album_image_url_hq)) { image in
                                        image
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    } placeholder: {
                                        // TODO: Add a placeholder image.
                                    }
                                    .frame(width: cellSize, height: cellSize)
                                }
                                .onAppear { Task { await homeViewModel.addAlbums() } }
                            } else {
                                NavigationLink(destination: AlbumInfoView(album: album)) {
                                    AsyncImage(url: URL(string: album.album_image_url_hq)) { image in
                                        image
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    } placeholder: {
                                        // TODO: Add a placeholder image.
                                    }
                                    .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, gridSpacing)
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    private var cellSize: CGFloat {
        return (UIScreen.main.bounds.width - (gridSpacing * 5)) / 3
    }
}
