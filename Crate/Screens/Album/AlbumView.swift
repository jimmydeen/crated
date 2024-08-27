import SwiftUI
import Kingfisher

struct AlbumView: View {
    @Environment(SharedUserViewModel.self) private var userViewModel
    @State var viewModel: AlbumViewModel

    private let coverPaddingBottom: CGFloat = 24
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let rowSpacing: CGFloat = 12
    private let rowsSpacing: CGFloat = 14
    private let shadowRadius: CGFloat = 12
    private let tracklistIndexFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.08
    private let tracklistNameFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.64
    private let tracklistPaddingLeading: CGFloat = UIScreen.main.bounds.width * 0.1
    private let tracklistPaddingTrailing: CGFloat = UIScreen.main.bounds.width * 0.14
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                if let urlString = viewModel.album.album_cover_url_high_quality,
                   let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .placeholder {
                            ImagePlaceholderView()
                        }
                        .frame(height: coverSize)
                        .shadow(radius: shadowRadius)
                }
                
                HStack {
                    Text(viewModel.album.album_type.uppercased())
                    
                    Spacer()
                    
                    Text(viewModel.album.album_release_date)
                        .padding(.trailing, 2)
                }
                .font(.caption2)
                .fontWeight(.regular)
                .foregroundColor(.gray)
                .offset(y: 4)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.album.album_name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.top, 2)
                        
                        Text(viewModel.album.album_artists.joined(separator: ", "))
                            .foregroundColor(.black.opacity(0.6))
                            .offset(y: -4)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 6)
                
                Button(
                    action: {
                        if userViewModel.user.user_favorites.contains(viewModel.album) {
                            userViewModel.removeFromFavorites(viewModel.album)
                        } else {
                            userViewModel.addToFavorites(viewModel.album)
                        }
                    },
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: userViewModel.user.user_favorites.contains(viewModel.album) ? "xmark": "plus")
                                .animation(.default)
                            
                            Text(userViewModel.user.user_favorites.contains(viewModel.album) ? "Remove from favorites": "Add to favorites")
                                .animation(.default)
                        }
                        .font(.system(size: 15))
                    }
                )
                .frame(width: coverSize)
            }
            .frame(width: coverSize)
            .padding(.vertical, coverPaddingBottom - 2)
            .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: rowsSpacing) {
                ForEach(viewModel.tracks, id: \.self) { track in
                    if track.id != viewModel.tracks[0].id {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                    
                    HStack(alignment: .top, spacing: rowSpacing) {
                        Text("\(track.track_index)")
                            .foregroundColor(.gray)
                            .frame(width: tracklistIndexFrameWidth)
                        
                        HStack {
                            Text("\(track.track_name)")
                            
                            Spacer()
                        }
                        .frame(width: tracklistNameFrameWidth)
                        
                        Spacer()
                        
                        Button(
                            action: {
                                
                            },
                            label: {
                                Image(systemName: "heart")
                                    .foregroundColor(.black)
                            }
                        )
                    }
                    .frame(height: 18)
                }
            }
            .padding(.leading, tracklistPaddingLeading)
            .padding(.trailing, tracklistPaddingTrailing)
            
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.02)
        }
        .onAppear {
            Task {
                await viewModel.fetchTracks()
            }
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        AlbumView(
            viewModel: AlbumViewModel(album: AlbumModel(
                album_name: "More Life",
                album_artists: ["Drake"],
                album_id: "1lXY618HWkwYKJWBRYR4MK",
                album_type: "album",
                album_release_date: "2017-03-18",
                album_cover_url_high_quality: "https://i.scdn.co/image/ab67616d0000b2734f0fd9dad63977146e685700",
                album_cover_url_low_quality: "https://i.scdn.co/image/ab67616d00001e024f0fd9dad63977146e685700",
                album_spotify_link: "https://open.spotify.com/album/1lXY618HWkwYKJWBRYR4MK"
            ))
        )
        .environment(userViewModel)
    }
}
