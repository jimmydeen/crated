import SwiftUI
import Kingfisher

struct FavoritesView: View {
    @State var viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Title(text: "Favorites")
            
            if !viewModel.isLoading {
                if viewModel.favorites.isEmpty {
                    EmptyMessageView(text: "No favorites just yet.")
                } else {
                    favorites
                }
            }
        }
        .padding([.horizontal, .top], .standard)
        .task {
            await viewModel.fetchFavorites()
        }
    }
    
    var favorites: some View {
        List(viewModel.favorites) { favorite in
            NavigationLink(destination: AlbumView(viewModel: AlbumViewModel(album: favorite))) {
                ResultListRowView(result: favorite)
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct FavoritesViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Favorites (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Favorites (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
