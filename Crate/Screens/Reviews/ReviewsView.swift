import SwiftUI
import Kingfisher

struct ReviewsView: View {
    @State var viewModel = ReviewsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Title(text: "Reviews")
                
                Spacer()
                
                NavigationLink(destination: CreateReviewView()) {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundColor(.blue)
                }
            }
            
            if viewModel.reviews.isEmpty {
                EmptyMessageView(text: "No reviews just yet.")
            } else {
                reviews
            }
            
            Spacer()
        }
        .padding([.horizontal, .top], .standard)
        .task {
            await viewModel.fetchReviews()
        }
    }
    
    var reviews: some View {
        List(viewModel.reviews, id: \.id) { review in
            ResultListRowView(result: review)
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct ReviewsViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Reviews (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Reviews (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
