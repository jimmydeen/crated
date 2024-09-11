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
                        CommonImagePlaceholderView()
                    }
                    .resizable()
            } else {
                CommonImagePlaceholderView()
            }
        }
        .onAppear {
            Task {
                do {
                    let fetchedAlbum = try await SpotifyAPIService.retrieveAlbum(for: album_id)
                    album = fetchedAlbum
                } catch {
                    print("Error fetching album: \(error)")
                }
            }
        }
        .onTapGesture {
            self.selectedAlbum = album
            withAnimation {
                self.isDisplayingAlbum = true
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
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.028
    private let profilePictureSize: CGFloat = UIScreen.main.bounds.width * 0.24
    private let rowCellCount: Int = 3
    private let titlePaddingTop: CGFloat = 84
    
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
                                    .padding(.bottom, 2)
                                
                                HStack(alignment: .center) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.caption)
                                    
                                    Text("Melbourne, Victoria")
                                        .font(.subheadline)
                                        .offset(x: -4, y: 1)
                                }
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.leading, 2)
                                
                                Spacer()
                                
                                HStack(spacing: 20) {
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
                                .padding(.leading, 4)
                            }
                            .frame(
                                width: UIScreen.main.bounds.width * 0.5,
                                height: self.profilePictureSize * 0.9
                            )
                            
                            Spacer()
                            
                            CommonImagePlaceholderView()
                                .clipShape(Circle())
                                .frame(width: self.profilePictureSize)
                                .padding(.trailing, 10)
                        }
                        .frame(height: self.profilePictureSize)
                        .padding(.horizontal, 36)
                        
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
                                        selectedAlbum: $album,
                                        isDisplayingAlbum: $isDisplayingAlbum,
                                        album_id: favorite
                                    )
                                    .frame(width: cellSize, height: cellSize)
                                }
                            }
                            .padding(.horizontal, self.gridSpacing)
                            .padding(.top, 36)
                        }
                    }
                    .padding(.top, titlePaddingTop)
                }
            }
            .zIndex(0)
            
            if isDisplayingAlbum, let album = album {
                AlbumView(
                    album: album,
                    displayBinding: $isDisplayingAlbum,
                    rating: self.userViewModel.ratings[album.id] ?? 0
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
