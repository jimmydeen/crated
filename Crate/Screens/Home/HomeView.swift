import SwiftUI
import Kingfisher

struct HomeAlbumView: View {
    @Binding var isDisplayingAlbum: Bool
    @Binding var selectedAlbum: AlbumModel?
    
    let album: AlbumModel
    
    private let cellSize: CGFloat = (UIScreen.main.bounds.width * 0.888) / 3
    
    init(
        album: AlbumModel,
        isDisplayingAlbum: Binding<Bool>,
        selectedAlbum: Binding<AlbumModel?>
    ) {
        self.album = album
        _isDisplayingAlbum = isDisplayingAlbum
        _selectedAlbum = selectedAlbum
    }
    
    var body: some View {
        KFImage(URL(string: self.album.image_url_hq ?? ""))
            .resizable()
            .frame(width: self.cellSize, height: self.cellSize)
            .onTapGesture {
                self.selectedAlbum = self.album
                withAnimation {
                    self.isDisplayingAlbum = true
                }
            }
    }
}

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
                    if self.showingGradient {
                        LinearGradient(
                            gradient: self.viewModel.gradient!,
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                }
                .animation(
                    .easeOut(duration: self.gradientAnimationDuration),
                    value: self.showingGradient
                )

                VStack(spacing: self.imagePaddingBottom) {
                    Image(uiImage: self.viewModel.cover!)
                        .resizable()
                        .frame(width: self.coverSize, height: self.coverSize)
                        .shadow(radius: self.shadowRadius)

                    VStack(alignment: .leading, spacing: self.cardElementSpacing) {
                        HStack {
                            Text(self.viewModel.album.type.uppercased())
                                .padding(self.albumTypePaddingNudgeLeading)
                            
                            Spacer()
                            
                            Text(self.viewModel.album.release_date)
                        }
                        .font(.caption2)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .offset(y: self.albumDetailsOffsetNudgeVertical)
                        
                        Text(self.viewModel.album.name)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, self.internalPadding)
                }
                .frame(width: self.coverSize)
                .padding(self.cardPaddingInternal)
                .background(
                    RoundedRectangle(cornerRadius: self.cardCornerRadius)
                        .fill(.white)
                        .shadow(radius: self.shadowRadius)
                )
                .padding(.top, self.cardPaddingTop)
            }
            
            Spacer()
        }
        .onAppear {
            Task {
                self.viewModel.fetchGradient()
                self.showingGradient = true
            }
        }
    }
}

struct HomeView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var viewModel: HomeViewModel = HomeViewModel()
    @State var isDisplayingAlbum: Bool = false
    @State var isDisplayingSignIn: Bool = false
    @State var selectedAlbum: AlbumModel?
    
    private let elementSpacing: CGFloat = 6
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.028
    private let rowCellCount: Int = 3
    private let titlePaddingTop: CGFloat = 60
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: self.elementSpacing) {
                    Button(
                        action: {
                            self.isDisplayingSignIn.toggle()
                        },
                        label: {
                            ZStack {
                                Image("sign-in-background")
                                    .resizable()
                                    .scaledToFill()
                                    .offset(y: -24)
                                    .mask(
                                        RoundedRectangle(cornerRadius: 12)
                                            .frame(
                                                width: UIScreen.main.bounds.width - 22,
                                                height: 200
                                            )
                                    )
                                
                                Text("Sign In")
                                    .font(.headline)
                                    .fontWeight(.regular)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(.white)
                                    )
                            }
                            .frame(width: UIScreen.main.bounds.width - 22, height: 200)
                            .padding(.bottom, 48)
                        }
                    )
                    
                    Text("New releases")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible()),
                            count: self.rowCellCount
                        ),
                        spacing: self.gridSpacing
                    ) {
                        ForEach(self.viewModel.albums, id: \.id) { album in
                            HomeAlbumView(
                                album: album,
                                isDisplayingAlbum: self.$isDisplayingAlbum,
                                selectedAlbum: self.$selectedAlbum
                            )
                            .if(album == self.viewModel.albums.last) { view in
                                view.onAppear {
                                    if album == self.viewModel.albums.last {
                                        Task {
                                            await self.viewModel.fetchAlbums()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, self.titlePaddingTop)
                .padding(.horizontal, self.gridSpacing)
            }
            .zIndex(0)
            
            if self.isDisplayingAlbum {
                AlbumView(
                    album: self.selectedAlbum!,
                    displayBinding: self.$isDisplayingAlbum,
                    rating: self.userViewModel.ratings[self.selectedAlbum!.id] ?? 0
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
        .onAppear {
            Task {
                await self.viewModel.fetchAlbums()
            }
        }
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
                      
        HomeView()
            .environment(userViewModel)
            .ignoresSafeArea(.all)
    }
}
