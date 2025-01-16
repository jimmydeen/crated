import SwiftUI
import Kingfisher

struct ReviewsView: View {
    @State var viewModel = ReviewsViewModel()
    
    private let reviewCoverWidth: CGFloat = 100
    private let reviewCoverHeight: CGFloat = 100
    
    var body: some View {
        VStack {
            if !viewModel.reviews.isEmpty {
                ForEach(Array(viewModel.reviews.keys), id: \.id) { album in
                    HStack {
                        KFImage(album.cover_hq)
                            .resizable()
                            .frame(width: reviewCoverWidth, height: reviewCoverHeight)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    
                    Text("No reviews just yet.")
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Reviews")
    }
}
