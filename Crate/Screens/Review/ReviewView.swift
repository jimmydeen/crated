import SwiftUI
import Kingfisher

struct ReviewView: View {
    @State var viewModel: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Title(text: viewModel.review.name)
            
            if viewModel.isFetched {
                KFImage(viewModel.album!.cover_hq)
                    .boxSize(.standard)
            }
            
            if let title = viewModel.review.title {
                Text(title)
            }
            
            if let description = viewModel.review.description {
                Text(description)
            }
            
            if let rating = viewModel.review.rating {
                Text("\(rating)/5")
            }
            
            Spacer()
        }
        .padding(.standard)
        .task {
            await viewModel.fetchAlbum()
        }
    }
}

struct ReviewViewPreviews: PreviewProvider {
    static var previews: some View {
        ReviewView(viewModel: ReviewViewModel(review: Test.review))
            .environment(Authentication())
            .previewDisplayName("Review (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ReviewView(viewModel: ReviewViewModel(review: Test.review))
            .environment(Authentication())
            .previewDisplayName("Review (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
