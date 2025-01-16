import SwiftUI
import Kingfisher

struct AlbumView: View {
    @State var viewModel: AlbumViewModel
    
    init(album: AlbumModel) {
        _viewModel = State(wrappedValue: AlbumViewModel(album: album))
    }
    
    init(track: TrackModel) {
        _viewModel = State(wrappedValue: AlbumViewModel(track: track))
    }
    
    private let buttonCornerRadius: CGFloat = 16
    private let buttonHeight: CGFloat = 22
    private let buttonPaddingHorizontal: CGFloat = 8
    private let buttonPaddingVertical: CGFloat = 4
    private let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.275
    private let coverShadowRadius: CGFloat = 6
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let signInButtonPaddingVertical: CGFloat = 16
    private let tracklistPaddingHorizontal: CGFloat = UIScreen.main.bounds.width * 0.16
    private let tracklistPaddingTop: CGFloat = 32
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isLoaded {
                VStack(alignment: .leading) {
                    KFImage(viewModel.album!.cover_hq)
                        .resizable()
                        .frame(height: coverSize)
                        .shadow(radius: coverShadowRadius)
                    
                    Text(viewModel.album!.name)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(viewModel.album!.artists.joined(separator: ", "))
                        .foregroundColor(.gray)
                }
                .frame(width: coverSize)
                .task {
                    await viewModel.fetchInfo()
                }
                
                HStack {
                    if viewModel.isAuthenticated {
                        ratingButton
                        
                        favoriteButton
                    } else {
                        NavigationLink(destination: AccountView()) {
                            Text("Sign in to rate and review")
                                .frame(height: buttonHeight)
                                .padding(.horizontal, signInButtonPaddingVertical)
                                .padding(.vertical, buttonPaddingVertical)
                                .background(Color.lightGray)
                                .cornerRadius(buttonCornerRadius)
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.bottom, tracklistPaddingTop)
                
                if !viewModel.tracks.isEmpty {
                    ForEach(viewModel.tracks, id: \.id) { track in
                        TrackRowView(viewModel: $viewModel, track: track)
                        
                        Divider()
                    }
                    .padding(.horizontal, tracklistPaddingHorizontal)
                }
            }
        }
        .task {
            if viewModel.isLoaded == false {
                await viewModel.fetchAlbum()
            }
        }
    }
    
    private var ratingButton: some View {
        ZStack {
            HStack(spacing: 3) {
                ForEach(0...4, id: \.self) { index in
                    if viewModel.rating - Double(index) > 0.5 {
                        Image(systemName: "star.fill")
                    } else if viewModel.rating - Double(index) == 0.5 {
                        Image(systemName: "star.leadinghalf.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
            }
            
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
            .frame(width: buttonWidth, height: buttonHeight)
        }
        .padding(.horizontal, buttonPaddingHorizontal)
        .padding(.vertical, buttonPaddingVertical)
        .background(Color.lightGray)
        .cornerRadius(buttonCornerRadius)
    }
    
    private var favoriteButton: some View {
        Button(
            action: {
                Task {
                    await viewModel.favoriteAlbum()
                }
            },
            label: {
                Image(systemName: "plus")
                    .rotationEffect(.degrees(viewModel.isFavorite ? 45 : 0))
                    .fontWeight(.semibold)
                    .frame(height: buttonHeight)
                    .padding(.horizontal, buttonPaddingHorizontal)
                    .padding(.vertical, buttonPaddingVertical)
                    .background(Color.lightGray)
                    .cornerRadius(buttonCornerRadius)
            }
        )
    }
}

struct TrackRowView: View {
    @State var isLiked: Bool = false
    
    @Binding var viewModel: AlbumViewModel
    
    let track: TrackModel
    
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
            
            Button(action: {
                isLiked.toggle()
                Task {
                    await viewModel.favoriteTrack(track: track)
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .black)
            }
        }
        .frame(height: trackRowHeight)
        .task {
            isLiked = viewModel.favorites.contains(track.id)
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(UserViewModel())
    }
}
