import SwiftUI
import Kingfisher

struct SearchResultView: View {
    @State var albumForTrack: AlbumModel?
    
    @Binding var viewModel: SearchViewModel
    
    let result: ResultProtocol
    
    private let coverSize: CGFloat = 48
    private let coverToDetailsSpacing: CGFloat = 12
    private let detailsLineSpacing: CGFloat = 6
    private let resultBoxCornerRadius: CGFloat = 8
    private let resultBoxPadding: CGFloat = 8
    
    var body: some View {
        NavigationLink(
            destination: {
                if (result as? TrackModel) != nil {
                    if let album = albumForTrack {
                        AlbumView(viewModel: AlbumViewModel(album: album))
                    } else {
                        EmptyView()
                    }
                } else if let album = result as? AlbumModel {
                    AlbumView(viewModel: AlbumViewModel(album: album))
                } else if let artist = result as? ArtistModel {
                    ArtistView(viewModel: ArtistViewModel(artist: artist))
                } else {
                    EmptyView()
                }
            }
        ) {
            HStack(alignment: .center) {
                KFImage(result.cover_hq)
                    .resizable()
                    .placeholder {
                        PlaceholderView()
                    }
                    .frame(width: coverSize, height: coverSize)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(result.name)
                    
                    if !result.artists.isEmpty {
                        Spacer()
                            .frame(height: detailsLineSpacing)
                        
                        Text(result.artists.joined(separator: ", "))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .frame(height: coverSize)
                .font(.subheadline)
                
                Spacer()
            }
            .padding(resultBoxPadding)
            .background(Color.lightGray)
            .cornerRadius(resultBoxCornerRadius)
        }
        .task {
            if let track = result as? TrackModel {
                do {
                    albumForTrack = try await MusicMetadataAPIService.fetchAlbumDetails(albumID: track.album_id)
                } catch {
                    print("Failed to fetch album details: \(error.localizedDescription)")
                    albumForTrack = nil
                }
            }
        }
    }
}

struct SearchView: View {
    @State var isSearching: Bool = false
    @State var viewModel: SearchViewModel = SearchViewModel()
    
    private let titlePaddingTop: CGFloat = 84
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 6) {
                    if !isSearching {
                        Text("Search")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        ZStack {
                            if viewModel.query.isEmpty {
                                HStack {
                                    Text("Search")
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                TextField("", text: $viewModel.query)
                                    .autocapitalization(.none)
                                    .foregroundColor(.black)
                                    .onChange(of: viewModel.query) {
                                        withAnimation {
                                            isSearching = true
                                        }
                                    }
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.lightGray)
                    )
                    
                    Picker("Segment", selection: $viewModel.segment) {
                        Text("Albums").tag(SearchSegment.album)
                        Text("Artists").tag(SearchSegment.artist)
                        Text("Tracks").tag(SearchSegment.track)
                    }
                    .disabled(!isSearching)
                    .opacity(isSearching ? 1 : 0)
                    .pickerStyle(.segmented)
                    
                    LazyVStack {
                        ForEach(viewModel.results, id: \.id) { result in
                            SearchResultView(viewModel: $viewModel, result: result)
                                .if(result.id == viewModel.results.last?.id) { view in
                                    view.task {
                                        await viewModel.fetchResults()
                                    }
                                }
                        }
                    }
                }
                .padding(.top, titlePaddingTop)
            }
            .ignoresSafeArea(.all)
            .padding(.horizontal)
        }
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        SearchView()
            .ignoresSafeArea(.all)
    }
}
