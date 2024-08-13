import SwiftUI

struct AlbumView: View {
    @Environment(SharedUserViewModel.self) private var userViewModel
    @State private var isFavorite = false
    @Binding var viewModel: AlbumViewModel
    
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
                Image(uiImage: viewModel.cover!)
                    .resizable()
                    .frame(height: coverSize)
                    .shadow(radius: shadowRadius)
                
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
                
                HStack {
                    Button(
                        action: {
                            userViewModel.addToFavorites(viewModel.album)
                            isFavorite.toggle()
                        },
                        label: {
                            if isFavorite {
                                HStack(spacing: 4) {
                                    Image(systemName: "xmark")
                                    
                                    Text("Remove from favorites")
                                }
                                .font(.system(size: 15))
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus")
                                    
                                    Text("Add to favorites")
                                }
                                .font(.system(size: 15))
                            }
                        }
                    )
                }
                .frame(width: coverSize)
            }
            .frame(width: coverSize)
            .padding(.bottom, coverPaddingBottom - 2)
            
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
                        
                        Image(systemName: "star")
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

struct AlbumViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        HomeView()
            .environment(userViewModel)
    }
}
