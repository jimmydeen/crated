import SwiftUI

struct HomeAlbumContextView: View {
    @State private var showGradient: Bool = false
    @Binding var viewModel: AlbumContextViewModel

    private let albumDetailsOffsetNudgeVertical: CGFloat = 4
    private let albumTypePaddingNudgeLeading: CGFloat = 2
    private let cardCornerRadius: CGFloat = 8
    private let cardPaddingTop: CGFloat = UIScreen.main.bounds.height * 0.05
    private let cardPaddingInternal: CGFloat = 30
    private let coverCornerRadius: CGFloat = 4
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let gradientHeight: CGFloat = 250
    private let imagePaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.015
    private let internalPadding: CGFloat = 8
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                ZStack {
                    if showGradient {
                        LinearGradient(
                            gradient: viewModel.gradient!,
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                        
                        LinearGradient(
                            gradient: viewModel.gradient!,
                            startPoint: .topTrailing,
                            endPoint: .center
                        )
                    }
                }
                .ignoresSafeArea(.all)
                .transition(.opacity)
                .animation(.easeOut(duration: 1.2), value: showGradient)

                VStack(spacing: imagePaddingBottom) {
                    Image(uiImage: viewModel.cover!)
                        .resizable()
                        .frame(width: coverSize, height: coverSize)
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 0)

                    VStack(alignment: .leading, spacing: 0) {
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
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 0)
                )
                .padding(.top, cardPaddingTop)
            }
            
            Spacer()
        }
        .onAppear {
            Task {
                viewModel.fetchGradient()
                showGradient = true
            }
        }
    }
}

struct HomeAlbumView: View {
    @State var viewModel: AlbumContextViewModel
    
    init(album: AlbumModel) {
        _viewModel = State(wrappedValue: AlbumContextViewModel(album: album))
    }
    
    var body: some View {
        NavigationLink(destination: HomeAlbumContextView(viewModel: $viewModel)) {
            if let cover = viewModel.cover {
                Image(uiImage: cover).resizable()
            } else {
                Rectangle().fill(Color.gray.opacity(0.2))
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
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: rowCellCount),
                    spacing: gridSpacing)
                {
                    ForEach(Array(viewModel.albums.enumerated()), id: \.offset) { index, album in
                        HomeAlbumView(album: album)
                            .frame(width: cellSize, height: cellSize)
                            .onAppear {
                                if index == viewModel.albums.count - (rowCellCount + 1) {
                                    Task {
                                        await viewModel.fetchAlbums()
                                    }
                                }
                            }
                    }
                }
                .padding(.horizontal, gridSpacing)
            }
            .navigationTitle("New releases")
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
