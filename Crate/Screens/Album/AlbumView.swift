import SwiftUI
import Kingfisher

struct AlbumView: View {
    @Environment(Authentication.self) private var auth
    
    @State var viewModel: AlbumViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isLoaded {
                VStack(alignment: .leading) {
                    KFImage(viewModel.album!.cover_hq)
                        .boxSize(.huge)
                        .boxShadow(.standard)
                    
                    Text(viewModel.album!.name)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(viewModel.album!.subtitle!)
                        .foregroundColor(.gray)
                }
                .frame(width: BoxSize.huge.rawValue)
                .task {
                    await viewModel.fetchTracks()
                }
                
                HStack {
                    if auth.isLoggedIn {
                        ratingButton
                        
                        favoriteButton
                            .task {
                                await viewModel.fetchInfo()
                            }
                    } else {
                        RoundedNavButton(text: "Sign in to rate and review", destination: AccountView())
                            .frame(width: BoxSize.huge.rawValue)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.bottom, .huge)
                
                tracklist
            }
        }
        .task {
            if !viewModel.isLoaded {
                await viewModel.fetchAlbum()
            }
        }
    }
    
    var ratingButton: some View {
        ZStack {
            stars(rating: viewModel.rating)
            
            HStack(spacing: 0) {
                ForEach(Array(stride(from: 0.5, to: 5.5, by: 0.5)), id: \.self) { rating in
                    Button(
                        action: {
                            Task {
                                await viewModel.rateAlbum(rating: rating)
                            }
                        }
                    ) {
                        Rectangle()
                            .fill(.clear)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.275, height: 22)
        }
        .padding(.horizontal, .small)
        .padding(.vertical, .tiny)
        .background(Color.lightGray)
        .cornerRadius(.large)
    }
    
    var favoriteButton: some View {
        Button(action: { viewModel.favoriteAlbum() }) {
            Image(systemName: "plus")
                .rotationEffect(.degrees(viewModel.isFavorite ? 45 : 0))
                .fontWeight(.semibold)
                .frame(height: 22)
                .padding(.horizontal, .small)
                .padding(.vertical, .tiny)
                .background(Color.lightGray)
                .cornerRadius(.large)
        }
    }
    
    var tracklist: some View {
        VStack {
            ForEach(viewModel.tracks, id: \.id) { track in
                TrackRowView(viewModel: $viewModel, track: track)
                
                Divider()
            }
            .padding(.horizontal, .standard)
        }
    }
    
    func stars(rating: Double) -> some View {
        HStack(spacing: 3) {
            ForEach(0...4, id: \.self) { index in
                if rating >= Double(index) + 1 {
                    Image(systemName: "star.fill")
                } else if rating >= Double(index) + 0.5 {
                    Image(systemName: "star.leadinghalf.fill")
                } else {
                    Image(systemName: "star")
                }
            }
        }
    }
}

struct TrackRowView: View {
    @Environment(Authentication.self) private var auth
    
    @Binding var viewModel: AlbumViewModel
    
    let track: Track
    
    var isLiked: Bool {
        viewModel.favorites.contains(track.id)
    }
    
    private let trackRowIndexWidth: CGFloat = UIScreen.main.bounds.width * 0.08
    private let trackRowTitleWidth: CGFloat = UIScreen.main.bounds.width * 0.7
    private let trackRowHeight: CGFloat = 24
    
    var body: some View {
        HStack(alignment: .bottom) {
            HStack {
                Text("\(track.index)")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .frame(width: trackRowIndexWidth)
            
            HStack {
                Text("\(track.name)")
                
                Spacer()
            }
            .frame(width: trackRowTitleWidth)
            
            if auth.isLoggedIn {
                Button(action: { viewModel.favoriteTrack(track: track) }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .black)
                }
            }
        }
        .frame(height: trackRowHeight)
    }
}

struct AlbumViewPreviews: PreviewProvider {
    static var previews: some View {
        AlbumView(viewModel: AlbumViewModel(album: Test.album))
            .environment(Authentication())
            .previewDisplayName("Album (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        AlbumView(viewModel: AlbumViewModel(album: Test.album))
            .environment(Authentication())
            .previewDisplayName("Album (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
