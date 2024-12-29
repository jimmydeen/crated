import SwiftUI
import Kingfisher

public enum SearchSegment: String, CaseIterable {
    case Albums = "album"
    case Artists = "artist"
    case Tracks = "track"
    
    var stringValue: String {
        return self.rawValue
    }
}

struct SearchResultView: View {
    let result: ResultProtocol
    
    private let boxBackgroundOpacity: CGFloat = 0.1
    private let boxCornerRadius: CGFloat = 8
    private let boxPadding: CGFloat = 8
    private let coverSize: CGFloat = 60
    private let coverSpacingFromDetails: CGFloat = 12
    private let detailsSpacing: CGFloat = 6
    
    var body: some View {
        HStack(alignment: .center, spacing: self.coverSpacingFromDetails) {
            KFImage(URL(string: result.image_url_hq ?? ""))
                .resizable()
                .placeholder {
                    CommonPlaceholderView()
                }
                .frame(width: self.coverSize, height: self.coverSize)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(self.result.name)
                
                if self.result.artists != [] {
                    Spacer()
                        .frame(height: self.detailsSpacing)
                    
                    Text(self.result.artists.joined(separator: ", "))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .frame(height: self.coverSize)
            .font(.footnote)
            
            Spacer()
        }
        .padding(self.boxPadding)
        .background(
            RoundedRectangle(cornerRadius: self.boxCornerRadius)
                .fill(Color.gray.opacity(self.boxBackgroundOpacity))
        )
    }
}

struct SearchView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var album: AlbumModel?
    @State var artist: ArtistModel?
    @State var isDisplayingAlbum: Bool = false
    @State var isDisplayingArtist: Bool = false
    @State var isSearching: Bool = false
    @State var isShowingTitle: Bool = true
    @State var viewModel: SearchViewModel = SearchViewModel()
    
    private let titlePaddingTop: CGFloat = 84
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 6) {
                    if self.isShowingTitle {
                        Text("Search")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        ZStack {
                            if self.viewModel.query.isEmpty {
                                HStack {
                                    Text("Search")
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                TextField("", text: self.$viewModel.query)
                                    .autocapitalization(.none)
                                    .foregroundColor(.black)
                                    .onChange(of: self.viewModel.query) {
                                        withAnimation {
                                            self.isShowingTitle = false
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
                            .fill(Colors.lightGray)
                    )
                    
                    Picker("Segment", selection: self.$viewModel.segment) {
                        Text("Albums").tag(SearchSegment.Albums)
                        Text("Artists").tag(SearchSegment.Artists)
                        Text("Tracks").tag(SearchSegment.Tracks)
                    }
                    .disabled(self.isShowingTitle)
                    .opacity(self.isShowingTitle ? 0 : 1)
                    .pickerStyle(.segmented)
                    
                    LazyVStack {
                        ForEach(self.viewModel.results, id: \.id) { result in
                            Button(
                                action: {
                                    self.destinationView(result: result)
                                },
                                label: {
                                    SearchResultView(result: result)
                                        .if(result.id == self.viewModel.results.last?.id) { view in
                                            view.task {
                                                await self.viewModel.fetchResults()
                                            }
                                        }
                                }
                            )
                        }
                    }
                }
                .padding(.top, self.titlePaddingTop)
            }
            .padding(.horizontal)
            
            if isDisplayingAlbum, let album = self.album {
                ZStack {
                    Color.white
                    
                    AlbumView(
                        album: album,
                        displayBinding: self.$isDisplayingAlbum,
                        rating: self.userViewModel.albumRatings[album.id] ?? 0
                    )
                }
                .transition(.move(edge: .trailing))
            }
            
            if self.isDisplayingArtist, let artist = self.artist {
                ZStack {
                    Color.white
                    
                    ArtistView(
                        artist: artist,
                        displayBinding: self.$isDisplayingArtist
                    )
                }
            }
        }
    }
    
    private func destinationView(result: ResultProtocol) {
        if let album = result as? AlbumModel {
            self.album = album
            
            withAnimation {
                isDisplayingAlbum.toggle()
            }
        } else if let artist = result as? ArtistModel {
            self.artist = artist
            
            withAnimation {
                isDisplayingArtist.toggle()
            }
        } else {
            return
        }
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)

        SearchView()
            .environment(userViewModel)
            .ignoresSafeArea(.all)
    }
}
