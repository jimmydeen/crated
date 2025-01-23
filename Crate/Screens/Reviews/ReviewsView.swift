import SwiftUI
import Kingfisher

struct ReviewsView: View {
    @State var viewModel = ReviewsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reviews")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            List(viewModel.reviews.map { $0 }, id: \.key.id) { _, review in
                SearchResultView(
                    result: review,
                    navigationView: AnyView(ReviewView(review: review))
                )
            }
            
            Spacer()
        }
    }
}

struct ReviewsViewPreview: PreviewProvider {
    static var previews: some View {
        ReviewsView()
            .environment(DisplayViewModel())
    }
}
