import SwiftUI

struct ReviewView: View {
    @State var viewModel: ReviewViewModel
    
    init(review: ReviewModel) {
        _viewModel = State(wrappedValue: ReviewViewModel(review: review))
    }
    
    init(review: ReviewModel, album: AlbumModel) {
        _viewModel = State(wrappedValue: ReviewViewModel(review: review, album: album))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.review.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Spacer()
            }
            
            if !viewModel.needToFetchAlbum {
                
            }
            
            Spacer()
        }
        .onAppear {
            if viewModel.needToFetchAlbum {
                Task {
                    await viewModel.fetchAlbum()
                }
            }
        }
    }
}

struct ReviewViewPreview: PreviewProvider {
    static var previews: some View {
        ReviewView(review: MockData.review)
            .environment(DisplayViewModel())
    }
}
