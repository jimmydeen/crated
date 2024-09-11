import SwiftUI
import Kingfisher

struct AlbumFavoriteNotificationView: View {
    let isBeingAdded: Bool
    
    private let cornerRadius: CGFloat = 12
    private let innerHorizontalPadding: CGFloat = 20
    private let innerVerticalPadding: CGFloat = 10
    private let shadowRadius: CGFloat = 2
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Album \(self.isBeingAdded ? "added to" : "removed from") favorites")
                .font(.headline)
                .padding(.horizontal, self.innerHorizontalPadding)
                .padding(.vertical, self.innerVerticalPadding)
                .background(.white)
                .cornerRadius(self.cornerRadius)
                .shadow(radius: self.shadowRadius)
        }
    }
}

struct AlbumTrackView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var isLiked: Bool
    
    let track: TrackModel
    
    private let indexWidth: CGFloat = UIScreen.main.bounds.width * 0.08
    private let spacing: CGFloat = 12
    private let titleWidth: CGFloat = UIScreen.main.bounds.width * 0.7
    
    var body: some View {
        HStack(alignment: .top, spacing: self.spacing) {
            Text("\(self.track.index)")
                .foregroundColor(.gray)
                .frame(width: self.indexWidth)
            
            HStack {
                Text("\(self.track.name)")
        
                Spacer()
            }
            .frame(width: self.titleWidth)
            
            Button(
                action: {
                    self.isLiked.toggle()
                    self.userViewModel.likeTrack(track)
                },
                label: {
                    Image(systemName: self.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(self.isLiked ? .red : .black)
                }
            )
        }
    }
}

struct AlbumView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var isFavorite: Bool = false
    @State var canRate: Bool = false
    @State var isRating: Bool = false
    @State var isShowingFavoriteButton: Bool = true
    @State var rating: Double
    @State var viewModel: AlbumViewModel
    @State var showNotification: Bool = false
    @Binding var displayBinding: Bool
    
    init(album: AlbumModel, displayBinding: Binding<Bool>, rating: Double) {
        _viewModel = State(wrappedValue: AlbumViewModel(album: album))
        _displayBinding = displayBinding
        _rating = State(wrappedValue: rating)
    }

    private let backButtonSpacing: CGFloat = 5
    private let coverPaddingBottom: CGFloat = 24
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let elementSpacing: CGFloat = 10
    private let isRatingCoverPaddingBottom: CGFloat = 12
    private let isRatingCoverPaddingTop: CGFloat = 60
    private let notificationPaddingBottom: CGFloat = 50
    private let paddingLeading: CGFloat = UIScreen.main.bounds.width * 0.16
    private let paddingTop: CGFloat = 66
    private let paddingTrailing: CGFloat = UIScreen.main.bounds.width * 0.16
    private let rowsSpacing: CGFloat = 14
    private let shadowRadius: CGFloat = 6
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack {
                        if !self.isRating {
                            HStack {
                                Button(
                                    action: {
                                        withAnimation {
                                            self.displayBinding = false
                                        }
                                    },
                                    label: {
                                        HStack(spacing: self.backButtonSpacing) {
                                            Image(systemName: "arrow.left")
                                            
                                            Text("Back")
                                        }
                                        .fontWeight(.medium)
                                    }
                                )
                                
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.5)
                        }
                        
                        VStack(alignment: .leading, spacing: self.elementSpacing) {
                            KFImage(URL(string: self.viewModel.album.image_url_hq ?? ""))
                                .placeholder {
                                    CommonImagePlaceholderView()
                                }
                                .resizable()
                                .frame(height: self.coverSize)
                                .padding(
                                    .top,
                                    self.isRating ? self.isRatingCoverPaddingTop : 0
                                )
                                .padding(
                                    .bottom,
                                    self.isRating ? self.isRatingCoverPaddingBottom : 0
                                )
                                .shadow(radius: self.shadowRadius)
                            
                            if !isRating {
                                HStack {
                                    Text(self.viewModel.album.type.uppercased())
                                    
                                    Spacer()
                                    
                                    Text(self.viewModel.album.release_date)
                                }
                                .font(.caption2)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                            }
                            
                            if !isRating {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(self.viewModel.album.name)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    
                                    Text(self.viewModel.album.artists.joined(separator: ", "))
                                        .foregroundColor(.black.opacity(0.6))
                                        .offset(y: -4)
                                }
                            }
                            
                            HStack {
                                Button(
                                    action: {
                                        if !self.isRating {
                                            self.canRate = true
                                            
                                            withAnimation {
                                                self.isRating = true
                                            }
                                            withAnimation(.easeOut(duration: 0.1)) {
                                                self.isShowingFavoriteButton = false
                                            }
                                        }
                                    },
                                    label: {
                                        ZStack {
                                            HStack(spacing: 0) {
                                                ForEach(1..<6) { count in
                                                    Image(systemName: starImageName(count: count))
                                                        .frame(width: 20, height: 20)
                                                }
                                            }
                                            
                                            if self.canRate {
                                                HStack(spacing: 0) {
                                                    ForEach(1..<11) { count in
                                                        Button(
                                                            action: {
                                                                let newRating = Double(count) * 0.5
                                                                if self.rating == newRating {
                                                                    self.rating = 0
                                                                } else {
                                                                    self.rating = Double(count) * 0.5
                                                                }
                                                            },
                                                            label: {
                                                                Rectangle()
                                                                    .foregroundStyle(Color.clear)
                                                                    .frame(
                                                                        width: 10,
                                                                        height: 36
                                                                    )
                                                            }
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: 22)
                                        .frame(width: self.coverSize * 0.55)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16).fill(Colors.lightGray)
                                        )
                                    }
                                )
                                .scaleEffect(
                                    self.isRating ? 1.55 : 1,
                                    anchor: .topLeading
                                )
                                
                                if isShowingFavoriteButton {
                                    Button(
                                        action: {
                                            withAnimation {
                                                self.showNotification = true
                                                if self.isFavorite {
                                                    self.userViewModel.removeFromFavorites(viewModel.album)
                                                } else {
                                                    self.userViewModel.addToFavorites(viewModel.album)
                                                }
                                                self.isFavorite.toggle()
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    self.showNotification = false
                                                }
                                            }
                                        },
                                        label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "plus")
                                                    .rotationEffect(.degrees(self.isFavorite ? 45 : 0))
                                                    .offset(y: 1.2)
                                            }
                                            .fontWeight(.semibold)
                                            .frame(height: 22)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16).fill(Colors.lightGray)
                                            )
                                        }
                                    )
                                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
                                }
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .frame(width: self.coverSize)
                        .padding(.bottom, 36)
                        
                        Spacer()
                    }
                    .padding(.top, self.paddingTop)
                    .zIndex(2)
                    
                    if self.isRating {
                        CommonDarkeningBlur()
                            .onTapGesture {
                                if self.rating != 0 {
                                    self.userViewModel.addToActivities(
                                        ActivityModel(
                                            username: self.userViewModel.user!.name,
                                            date: Date.now,
                                            type: ActivityType.AlbumRating,
                                            album: self.viewModel.album,
                                            rating: self.rating
                                        )
                                    )
                                    self.userViewModel.ratings[self.viewModel.album.id] = self.rating
                                }
                                self.canRate = false
                                withAnimation {
                                    self.isRating = false
                                }
                                withAnimation {
                                    self.isShowingFavoriteButton = true
                                }
                            }
                            .zIndex(1)
                    }
                    
                    VStack(alignment: .leading, spacing: self.rowsSpacing) {
                        Spacer()
                            .frame(height: self.coverSize * 2)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(self.viewModel.album.name)
                                .font(.title)
                                .fontWeight(.semibold)
                                .opacity(0)
                            
                            Text(self.viewModel.album.artists.joined(separator: ", "))
                                .foregroundColor(.black.opacity(0.6))
                                .offset(y: -4)
                                .opacity(0)
                        }
                        .frame(width: self.coverSize)
                        
                        ForEach(self.viewModel.tracks, id: \.self) { track in
                            if track.id != self.viewModel.tracks[0].id {
                                Rectangle()
                                    .foregroundColor(.gray.opacity(0.2))
                                    .frame(height: 1)
                            }
                            
                            if self.userViewModel.likedTracks[track.album_id] != nil {
                                let isLiked = self.userViewModel.likedTracks[track.album_id]![track.id] ?? false
                                AlbumTrackView(isLiked: isLiked, track: track)
                                    .frame(height: 18)
                            } else {
                                AlbumTrackView(isLiked: false, track: track)
                                    .frame(height: 18)
                            }
                        }
                        
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height * 0.05)
                    }
                    .padding(.leading, self.paddingLeading)
                    .padding(.trailing, self.paddingTrailing)
                    .zIndex(0)
                }
            }
            .onAppear {
                self.isFavorite = userViewModel.favoriteContainsAlbum(viewModel.album)
                Task {
                    await self.viewModel.fetchTracks()
                }
            }
            
            if self.showNotification {
                AlbumFavoriteNotificationView(
                    isBeingAdded: self.userViewModel.favoriteContainsAlbum(
                        self.viewModel.album
                    )
                )
                .padding(.bottom, notificationPaddingBottom)
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .background(Color.white)
    }
    
    private func starImageName(count: Int) -> String {
        if Double(count) - 0.5 == self.rating {
            return "star.leadinghalf.filled"
        } else if Double(count) > self.rating {
            return "star"
        } else {
            return "star.fill"
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
        
        AlbumView(
            album: AlbumModel(
                name: "More Life",
                id: "1lXY618HWkwYKJWBRYR4MK",
                artists: ["Drake"],
                type: "album",
                release_date: "2017-03-18",
                spotify_link: "https://open.spotify.com/album/1lXY618HWkwYKJWBRYR4MK",
                image_url_hq: "https://i.scdn.co/image/ab67616d0000b2734f0fd9dad63977146e685700",
                image_url_lq: "https://i.scdn.co/image/ab67616d00001e024f0fd9dad63977146e685700"
            ),
            displayBinding: .constant(true),
            rating: 0
        )
        .environment(userViewModel)
        .ignoresSafeArea(.all)
    }
}
