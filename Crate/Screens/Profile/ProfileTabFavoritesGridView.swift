import SwiftUI

struct FavoriteItemView: View {
    let favorite: IdentifiableProtocol
    
    var body: some View {
        if let urlString = favorite.image_url_high_quality,
           let url = URL(string: urlString) {
            AsyncImageView(for: url)
        }
    }
}

struct ProfileTabFavoritesGridView: View {
    @Environment(SharedUserViewModel.self) private var userViewModel
    @Binding var viewModel: ProfileViewModel
    
    private let gridSpacing: CGFloat = 12
    private let rowCellCount: Int = 3
    
    var body: some View {
        if userViewModel.user.user_favorites.isEmpty {
            VStack {
                Spacer()
                
                Text("No favorites added.")
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
        else {
            GeometryReader { gr in
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: rowCellCount
                    ),
                    spacing: gridSpacing)
                {
                    ForEach(Array(userViewModel.user.user_favorites), id: \.self) { favorite in
                        FavoriteItemView(favorite: favorite)
                            .frame(
                                width: (gr.size.width - (gridSpacing * CGFloat(rowCellCount - 1))) / CGFloat(rowCellCount),
                                height: (gr.size.width - (gridSpacing * CGFloat(rowCellCount - 1))) / CGFloat(rowCellCount)
                            )
                    }
                }
            }
        }
    }
}

struct ProfileTabFavoritesGridViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
