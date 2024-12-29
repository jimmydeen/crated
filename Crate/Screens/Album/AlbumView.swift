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
                    self.userViewModel.likeTrackInAlbum(track: track)
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
    @Environment(CommonDisplayViewModel.self) private var displayViewModel
    @Environment(CommonUserViewModel.self) private var userViewModel
    
    @State private var canRate: Bool = false
    @State private var isFavorite: Bool = false
    @State private var isRating: Bool = false
    @State private var isShowingFavoriteButton: Bool = true
    @State private var isTracksLoaded: Bool = false
    @State private var rating: Double
    @State private var viewModel: AlbumViewModel
    @State private var showNotification: Bool = false
    
    @Binding var isDisplaying: Bool
    
    init(album: AlbumModel, displayBinding: Binding<Bool>, rating: Double) {
        _viewModel = State(wrappedValue: AlbumViewModel(album: album))
        _isDisplaying = displayBinding
        _rating = State(wrappedValue: rating)
    }

    private let artistsOffsetVertical: CGFloat = -4
    private let backButtonSpacing: CGFloat = 5
    private let backgroundScaleEffect: CGFloat = 1.2
    private let coverPaddingBottom: CGFloat = 24
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let elementSpacing: CGFloat = 10
    private let favoriteButtonCornerRadius: CGFloat = 16
    private let favoriteButtonHeight: CGFloat = 22
    private let favoriteButtonInternalPaddingHorizontal: CGFloat = 8
    private let favoriteButtonInternalPaddingVertical: CGFloat = 4
    private let favoriteButtonOffsetVertical: CGFloat = 1.2
    private let favoritedRotation: CGFloat = 45
    private let notificationPaddingBottom: CGFloat = 50
    private let paddingLeading: CGFloat = UIScreen.main.bounds.width * 0.16
    private let paddingTop: CGFloat = 66
    private let paddingTrailing: CGFloat = UIScreen.main.bounds.width * 0.16
    private let notificationDelay: CGFloat = 2.0
    private let ratingAnimationDuration: CGFloat = 0.1
    private let ratingCoverPaddingBottom: CGFloat = 12
    private let ratingCoverPaddingTop: CGFloat = 60
    private let rowsSpacing: CGFloat = 14
    private let shadowRadius: CGFloat = 6
    private let starHitboxHeight: CGFloat = 36
    private let starHitboxWidth: CGFloat = 10
    private let starImageSize: CGFloat = 20
    private let starRatingCornerRadius: CGFloat = 18
    private let starRatingHeight: CGFloat = 22
    private let starRatingInternalPaddingHorizontal: CGFloat = 8
    private let starRatingInternalPaddingVertical: CGFloat = 4
    private let starRatingScaleEffect: CGFloat = 1.55
    private let starRatingWidth: CGFloat = UIScreen.main.bounds.width * 0.275
    private let tracklistDividerHeight: CGFloat = 1.0
    private let tracklistPaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.05
    private let tracklistPaddingTop: CGFloat = UIScreen.main.bounds.width
    private let trackWidth: CGFloat = 18
    
    private var starCount: Int = 5
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack(alignment: .leading, spacing: self.rowsSpacing) {
                        VStack(alignment: .leading, spacing: 0) {
                            Color.clear
                                .frame(height: self.tracklistPaddingTop)
                            
                            Text(self.viewModel.album.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text(self.viewModel.album.artists.joined(separator: ", "))
                                .foregroundColor(.gray)
                                .offset(y: self.artistsOffsetVertical)
                        }
                        .frame(width: self.coverSize)
                        .opacity(0)
                        
                        if self.isTracksLoaded {
                            ForEach(self.viewModel.tracks, id: \.self) { track in
                                if track.id != self.viewModel.tracks[0].id {
                                    Rectangle()
                                        .foregroundColor(Colors.lightGray)
                                        .frame(height: self.tracklistDividerHeight)
                                }
                                
                                AlbumTrackView(isLiked: self.userViewModel.likedTracksByAlbum[track.album_id] != nil ? true : false, track: track)
                                    .frame(height: self.trackWidth)
                            }
                        }
                        
                        Spacer()
                            .frame(height: self.tracklistPaddingBottom)
                    }
                    .padding(.leading, self.paddingLeading)
                    .padding(.trailing, self.paddingTrailing)
                    
                    if self.isRating {
                        CommonBackgroundBlur()
                            .onTapGesture {
                                if self.rating != 0 {
                                    self.userViewModel.addUserActivity(
                                        ActivityModel(
                                            username: self.userViewModel.user!.name,
                                            date: Date.now,
                                            type: ActivityType.AlbumRating,
                                            album: self.viewModel.album,
                                            rating: self.rating
                                        )
                                    )
                                    self.userViewModel.albumRatings[self.viewModel.album.id] = self.rating
                                }
                                self.canRate = false
                                
                                withAnimation {
                                    self.displayViewModel.isDisplayingNavigation = true
                                    self.isRating = false
                                    self.isShowingFavoriteButton = true
                                }
                            }
                            .scaleEffect(self.backgroundScaleEffect, anchor: .top)
                    }
                    
                    VStack {
                        if !self.isRating {
                            HStack {
                                Button(
                                    action: {
                                        withAnimation {
                                            self.isDisplaying = false
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
                            .frame(width: self.coverSize)
                        }
                        
                        VStack(alignment: .leading, spacing: self.elementSpacing) {
                            KFImage(URL(string: self.viewModel.album.image_url_hq ?? ""))
                                .resizable()
                                .frame(height: self.coverSize)
                                .padding(.top, self.isRating ? self.ratingCoverPaddingTop : 0)
                                .padding(.bottom, self.isRating ? self.ratingCoverPaddingBottom : 0)
                                .shadow(radius: self.shadowRadius)
                            
                            if !self.isRating {
                                HStack {
                                    Text(self.viewModel.album.type.uppercased())
                                    
                                    Spacer()
                                    
                                    Text(self.viewModel.album.release_date)
                                }
                                .font(.caption2)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                            }
                            
                            if !self.isRating {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(self.viewModel.album.name)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    
                                    Text(self.viewModel.album.artists.joined(separator: ", "))
                                        .foregroundColor(.gray)
                                        .offset(y: self.artistsOffsetVertical)
                                }
                            }
                            
                            HStack {
                                Button(
                                    action: {
                                        if !self.isRating {
                                            self.canRate = true
                                            
                                            withAnimation {
                                                self.isRating = true
                                                self.displayViewModel.isDisplayingNavigation = false
                                            }
                                            withAnimation(.easeOut(duration: self.ratingAnimationDuration)) {
                                                self.isShowingFavoriteButton = false
                                            }
                                        }
                                    },
                                    label: {
                                        ZStack {
                                            HStack(spacing: 0) {
                                                ForEach(1..<(self.starCount + 1), id: \.self) { count in
                                                    Image(systemName: self.starImageName(count: count))
                                                        .frame(width: self.starImageSize, height: self.starImageSize)
                                                }
                                            }
                                            
                                            if self.canRate {
                                                HStack(spacing: 0) {
                                                    ForEach(1..<(self.starCount + 1), id: \.self) { ratingValue in
                                                        Button(
                                                            action: {
                                                                let newRating = Double(ratingValue) * 0.5
                                                                if self.rating == newRating {
                                                                    self.rating = 0
                                                                } else {
                                                                    self.rating = Double(ratingValue) * 0.5
                                                                }
                                                            },
                                                            label: {
                                                                Rectangle()
                                                                    .foregroundStyle(Color.clear)
                                                                    .frame(
                                                                        width: self.starHitboxWidth,
                                                                        height: self.starHitboxHeight
                                                                    )
                                                            }
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: self.starRatingHeight)
                                        .frame(width: self.starRatingWidth)
                                        .padding(.horizontal, self.starRatingInternalPaddingHorizontal)
                                        .padding(.vertical, self.starRatingInternalPaddingVertical)
                                        .background(Colors.lightGray)
                                        .cornerRadius(self.starRatingCornerRadius)
                                    }
                                )
                                .scaleEffect(self.isRating ? self.starRatingScaleEffect : 1, anchor: .topLeading)
                                
                                if self.isShowingFavoriteButton {
                                    Button(
                                        action: {
                                            withAnimation {
                                                self.showNotification = true
                                                if self.isFavorite {
                                                    self.userViewModel.removeAlbumFromFavorites(album: self.viewModel.album)
                                                } else {
                                                    self.userViewModel.addAlbumToFavorites(viewModel.album)
                                                }
                                                self.isFavorite.toggle()
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + self.notificationDelay) {
                                                    self.showNotification = false
                                                }
                                            }
                                        },
                                        label: {
                                            Image(systemName: "plus")
                                                .rotationEffect(.degrees(self.isFavorite ? self.favoritedRotation : 0))
                                                .offset(y: self.favoriteButtonOffsetVertical)
                                                .fontWeight(.semibold)
                                                .frame(height: self.favoriteButtonHeight)
                                                .padding(.horizontal, self.favoriteButtonInternalPaddingHorizontal)
                                                .padding(.vertical, self.favoriteButtonInternalPaddingVertical)
                                                .background(Colors.lightGray)
                                                .cornerRadius(self.favoriteButtonCornerRadius)
                                        }
                                    )
                                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
                                }
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .frame(width: self.coverSize)
                        
                        Spacer()
                    }
                    .padding(.top, self.paddingTop)
                }
            }
            .task {
                self.isFavorite = self.userViewModel.isAlbumFavorite(album: self.viewModel.album)
                await self.viewModel.fetchTracks()
                await MainActor.run {
                    self.isTracksLoaded = true
                }
            }
            
            if self.showNotification {
                AlbumFavoriteNotificationView(
                    isBeingAdded: self.userViewModel.isAlbumFavorite(
                        album: self.viewModel.album
                    )
                )
                .padding(.bottom, self.notificationPaddingBottom)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
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
        @State var displayViewModel = CommonDisplayViewModel()
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
        .environment(displayViewModel)
        .environment(userViewModel)
        .ignoresSafeArea(.all)
    }
}
