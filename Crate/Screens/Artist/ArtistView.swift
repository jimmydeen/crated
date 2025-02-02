import SwiftUI
import Kingfisher

struct ArtistView: View {
    @State var viewModel: ArtistViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Title(text: viewModel.artist.name)
                    .padding(.horizontal, .standard)
                
                KFImage(viewModel.artist.cover_hq)
                    .boxSize(.huge)
                    .padding(.bottom, .extraHuge)
                    .padding(.horizontal, .standard)
                
                if !viewModel.albums.isEmpty {
                    Subtitle(text: "Albums")
                        .padding(.horizontal, .standard)
                    
                    HorizontalCarouselView(data: viewModel.albums) { album in
                        NavigationLink(destination: album.searchView()) {
                            KFImage(album.cover_hq)
                                .boxSize(.large)
                        }
                    }
                }
                
                if !viewModel.compilations.isEmpty {
                    Subtitle(text: "Compilations")
                        .padding(.horizontal, .standard)
                    
                    HorizontalCarouselView(data: viewModel.compilations) { album in
                        NavigationLink(destination: album.searchView()) {
                            KFImage(album.cover_hq)
                                .boxSize(.large)
                        }
                    }
                }
                
                if !viewModel.singles.isEmpty {
                    Subtitle(text: "Singles")
                        .padding(.horizontal, .standard)
                    
                    HorizontalCarouselView(data: viewModel.singles) { album in
                        NavigationLink(destination: album.searchView()) {
                            KFImage(album.cover_hq)
                                .boxSize(.large)
                        }
                    }
                }
            }
            .task {
                await viewModel.retrieveAlbums()
            }
        }
    }
}

struct ArtistViewPreviews: PreviewProvider {
    static var previews: some View {
        ArtistView(viewModel: ArtistViewModel(artist: Test.artist))
            .environment(Authentication())
            .previewDisplayName("Artist (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ArtistView(viewModel: ArtistViewModel(artist: Test.artist))            .environment(Authentication())
            .previewDisplayName("Artist (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
