import SwiftUI
import Kingfisher

struct ArtistView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var viewModel: ArtistViewModel
    @State var isDisplayingAlbum: Bool = false
    @State var album: AlbumModel?
    
    init(artist: ArtistModel) {
        _viewModel = State(wrappedValue: ArtistViewModel(artist: artist))
    }
    
    private let elementSpacing: CGFloat = 6
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.034
    private let rowCellCount: Int = 2
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: elementSpacing) {
                    KFImage(URL(string: self.viewModel.artist.image_url_hq ?? ""))
                        .placeholder {
                            CommonImagePlaceholderView()
                        }
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width
                        )
                        .padding(.bottom, 48)
                    
                    HStack {
                        Text(self.viewModel.artist.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), alignment: .leading),
                            GridItem(.flexible(), alignment: .trailing)
                        ],
                        spacing: self.gridSpacing
                    ) {
                        ForEach(self.viewModel.albums, id: \.id) { album in
                            KFImage(URL(string: album.image_url_hq ?? ""))
                                .resizable()
                                .placeholder {
                                    CommonImagePlaceholderView()
                                }
                                .frame(width: self.cellSize, height: self.cellSize)
                                .onTapGesture {
                                    withAnimation {
                                        self.album = album
                                        self.isDisplayingAlbum = true
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, self.gridSpacing)
                }
            }
            .onAppear {
                Task {
                    if self.viewModel.albums.isEmpty {
                        await self.viewModel.retrieveAlbums()
                    }
                }
            }
            .zIndex(0)
            
            if isDisplayingAlbum {
                AlbumView(
                    album: album!,
                    displayBinding: $isDisplayingAlbum,
                    rating: self.userViewModel.ratings[album!.id] ?? 0
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
        .background(Color.white)
    }
    
    private var cellSize: CGFloat {
        let totalSpace = UIScreen.main.bounds.width - (self.gridSpacing * (CGFloat(self.rowCellCount) + 1))
        let cellSize = totalSpace / CGFloat(self.rowCellCount)
        return cellSize
    }
}

struct ArtistViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
                      
        ArtistView(
            artist: ArtistModel(
                name: "Drake",
                id: "3TVXtAsR1Inumwj472S9r4",
                artists: [],
                image_url_hq: "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9",
                image_url_lq: "https://i.scdn.co/image/ab676161000051744293385d324db8558179afd9"
            )
        )
        .environment(userViewModel)
    }
}
