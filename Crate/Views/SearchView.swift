import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $searchViewModel.selectedSegment) {
                    Text("Albums").tag("albums")
                    Text("Artists").tag("artists")
                    Text("Songs").tag("songs")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: searchViewModel.selectedSegment) {
                    searchViewModel.fetchResults()
                }
                
                if searchViewModel.results.isEmpty {} else {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(0..<searchViewModel.results.count, id: \.self) { index in
                                let item = searchViewModel.results[index]
                                buildResultView(for: item, at: index)
                                    .onAppear {
                                        if index == searchViewModel.results.count - 1 {
                                            loadMoreResults(for: item)
                                        }
                                    }
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
                Spacer()
            }
            .navigationTitle("Search")
        }
        .searchable(text: $searchViewModel.query)
    }
    
    @ViewBuilder
    private func buildResultView(for item: IdentifiableModel, at index: Int) -> some View {
        if let album = item as? AlbumModel {
            AlbumResultView(album: album)
        } else if let artist = item as? ArtistModel {
            ArtistResultView(artist: artist)
        } else if let track = item as? TrackModel {
            TrackResultView(track: track)
        } else {
            EmptyView()
        }
    }
    
    private func loadMoreResults(for item: IdentifiableModel) {
        if item is AlbumModel {
            searchViewModel.refreshAlbums()
        } else if item is ArtistModel {
            searchViewModel.refreshArtists()
        } else if item is TrackModel {
            searchViewModel.refreshSongs()
        }
    }
}

struct ArtistResultView: View {
    let artist: ArtistModel
    
    private let coverSize: CGFloat = 60
    private let resultPaddingExternal: CGFloat = 8
    private let resultPaddingInternal: CGFloat = 16
    private let resultPaddingLeading: CGFloat = 2
    
    var body: some View {
        HStack(alignment: .center) {
            if artist.artist_image_url_lq != "" {
                AsyncImage(url: URL(string: artist.artist_image_url_lq)) { phase in
                    phase.image?
                        .resizable()
                        .frame(width: coverSize, height: coverSize)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .padding(.leading, resultPaddingLeading)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: coverSize, height: coverSize)
            }
            
            Text(artist.artist_name)
                .font(.footnote)
                .frame(height: coverSize)
                .padding(.leading, resultPaddingLeading)
            
            Spacer()
        }
        .padding(resultPaddingExternal)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.12))
        )
        .padding(.horizontal)
    }
}

struct TrackResultView: View {
    let track: TrackModel
    
    private let coverSize: CGFloat = 60
    private let resultPaddingExternal: CGFloat = 8
    private let resultPaddingInternal: CGFloat = 16
    private let resultPaddingLeading: CGFloat = 2
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: track.track_image_url_lq)) { phase in
                phase.image?
                    .resizable()
                    .frame(width: coverSize, height: coverSize)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 4)
                    )
            }
            .padding(.leading, resultPaddingLeading)
            
            VStack(alignment: .leading) {
                Text(track.track_name)
                    .padding(.top, resultPaddingInternal)
                    .foregroundColor(.black)
                
                Spacer()
                Text(track.track_artists.joined(separator: ", "))
                    .padding(.bottom, resultPaddingInternal)
                    .foregroundColor(.gray)
            }
            .font(.footnote)
            .frame(height: coverSize)
            .padding(.leading, resultPaddingLeading)
            
            Spacer()
        }
        .padding(resultPaddingExternal)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.12))
        )
        .padding(.horizontal)
    }
}
