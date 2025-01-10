import SwiftUI
import Kingfisher

struct AlbumView: View {
    @State var viewModel: AlbumViewModel
    
    private let buttonCornerRadius: CGFloat = 16
    private let buttonHeight: CGFloat = 22
    private let buttonPaddingHorizontal: CGFloat = 8
    private let buttonPaddingVertical: CGFloat = 4
    private let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.275
    private let coverShadowRadius: CGFloat = 6
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let tracklistPaddingHorizontal: CGFloat = UIScreen.main.bounds.width * 0.16
    private let tracklistPaddingTop: CGFloat = 32
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                KFImage(viewModel.album.cover_hq)
                    .resizable()
                    .frame(height: coverSize)
                    .shadow(radius: coverShadowRadius)
                
                Text(viewModel.album.name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(viewModel.album.artists.joined(separator: ", "))
                    .foregroundColor(.gray)
            }
            .frame(width: coverSize)
            
            HStack {
                ratingButton
                
                favoriteButton
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.bottom, tracklistPaddingTop)
            
            if !viewModel.tracks.isEmpty {
                ForEach(viewModel.tracks, id: \.id) { track in
                    TrackRomView(viewModel: $viewModel, track: track)
                    
                    Divider()
                }
                .padding(.horizontal, tracklistPaddingHorizontal)
            }
        }
        .task {
            await viewModel.fetchTracksInfo()
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
                            viewModel.rateAlbum(rating)
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

struct TrackRomView: View {
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
                    await viewModel.favoriteTrack(track)
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
        AlbumView(viewModel: AlbumViewModel(album: MockData.album))
    }
}
