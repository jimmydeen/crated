import SwiftUI
import Kingfisher

enum ProfileTab: String, CaseIterable {
    case Favorites = "person.fill"
    case History = "clock"
    case ListeningStats = "chart.bar.fill"
}

struct ProfileViewFavoriteAlbum: View {
    @State var album: AlbumModel? = nil
    @Binding var selectedAlbum: AlbumModel?
    @Binding var isDisplayingAlbum: Bool
    
    let album_id: String
    
    var body: some View {
        VStack {
            if let album = album {
               KFImage(URL(string: album.image_url_hq ?? ""))
                    .placeholder {
                        CommonPlaceholderView()
                    }
                    .resizable()
                    .onTapGesture {
                        self.selectedAlbum = album
                        withAnimation {
                            self.isDisplayingAlbum = true
                        }
                    }
            } else {
                CommonPlaceholderView()
            }
        }
        .task {
            do {
                let fetchedAlbum = try await SpotifyAPIService.fetchAlbumDetails(albumID: album_id)
                album = fetchedAlbum
            } catch {
                print("Error fetching album: \(error)")
            }
        }
    }
}

struct ProfileView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var currentTab: ProfileTab = ProfileTab.Favorites
    @State var currentlyShowingFriendsPopup: Bool = false
    @State var isDisplayingAlbum: Bool = false
    @State var album: AlbumModel?
    
    private let cellSize: CGFloat = (UIScreen.main.bounds.width * 0.888) / 3
    private let detailsHeight: CGFloat = UIScreen.main.bounds.width * 0.216
    private let detailsPaddingLeading: CGFloat = 2
    private let detailsWidth: CGFloat = UIScreen.main.bounds.width * 0.5
    private let fullDetailsPaddingHorizontal: CGFloat = 36
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.028
    private let interactionButtonsPaddingLeading: CGFloat = 4
    private let interactionButtonsSpacing: CGFloat = 20
    private let profilePicturePaddingTrailing: CGFloat = 10
    private let profilePictureSize: CGFloat = UIScreen.main.bounds.width * 0.24
    private let rowCellCount: Int = 3
    private let suburbOffsetX: CGFloat = -4
    private let suburbOffsetY: CGFloat = 1
    private let titlePaddingTop: CGFloat = 84
    private let usernamePaddingBottom: CGFloat = 2
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                if let user = self.userViewModel.user {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("@\(user.name)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, self.usernamePaddingBottom)
                                
                                HStack(alignment: .center) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.caption)
                                    
                                    Text("Melbourne, Victoria")
                                        .font(.subheadline)
                                        .offset(
                                            x: self.suburbOffsetX,
                                            y: self.suburbOffsetY
                                        )
                                }
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.leading, self.detailsPaddingLeading)
                                
                                Spacer()
                                
                                HStack(spacing: self.interactionButtonsSpacing) {
                                    Button(
                                        action: { self.currentlyShowingFriendsPopup = true },
                                        label: {
                                            Text("Friends")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                                .underline()
                                        }
                                    )
                                    
                                    Button(
                                        action: { },
                                        label: {
                                            Text("Edit Profile")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                                .underline()
                                        }
                                    )
                                }
                                .padding(.leading, self.interactionButtonsPaddingLeading)
                            }
                            .frame(
                                width: self.detailsWidth,
                                height: self.detailsHeight
                            )
                            
                            Spacer()
                            
                            CommonPlaceholderView()
                                .clipShape(Circle())
                                .frame(width: self.profilePictureSize)
                                .padding(.trailing, self.profilePicturePaddingTrailing)
                        }
                        .frame(height: self.profilePictureSize)
                        .padding(.horizontal, self.fullDetailsPaddingHorizontal)
                        
                        if let favoritesSet = user.user_profile.favorites as? Set<String>,
                           !favoritesSet.isEmpty {
                            LazyVGrid(
                                columns: Array(
                                    repeating: GridItem(.flexible()),
                                    count: self.rowCellCount
                                ),
                                spacing: self.gridSpacing
                            ) {
                                ForEach(Array(favoritesSet), id: \.self) { favorite in
                                    ProfileViewFavoriteAlbum(
                                        selectedAlbum: self.$album,
                                        isDisplayingAlbum: self.$isDisplayingAlbum,
                                        album_id: favorite
                                    )
                                    .frame(width: self.cellSize, height: self.cellSize)
                                }
                            }
                            .padding(.horizontal, self.gridSpacing)
                            .padding(.top, self.fullDetailsPaddingHorizontal)
                        }
                    }
                    .padding(.top, self.titlePaddingTop)
                }
            }
            .zIndex(0)
            
            if self.isDisplayingAlbum, let album = album {
                AlbumView(
                    album: album,
                    displayBinding: self.$isDisplayingAlbum,
                    rating: self.userViewModel.albumRatings[album.id] ?? 0
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
    }
}

struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
        
        ProfileView()
            .environment(userViewModel)
            .ignoresSafeArea(.all)
    }
}
