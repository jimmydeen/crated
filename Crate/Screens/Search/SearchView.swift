import SwiftUI

public enum SearchSegment: String, CaseIterable {
    case Albums = "album"
    case Artists = "artist"
    case Tracks = "track"
    
    var stringValue: String {
        return self.rawValue
    }
}


struct SearchResultView: View {
    let result: IdentifiableProtocol
    
    private let boxBackgroundOpacity: CGFloat = 0.1
    private let boxCornerRadius: CGFloat = 8
    private let boxPadding: CGFloat = 8
    private let coverSize: CGFloat = 60
    private let coverSpacingFromDetails: CGFloat = 12
    private let detailsSpacing: CGFloat = 6
    
    var body: some View {
        HStack(alignment: .center, spacing: coverSpacingFromDetails) {
            if let urlString = result.image_url_low_quality,
               let url = URL(string: urlString) {
                AsyncImageView(for: url)
                    .frame(width: coverSize, height: coverSize)
            }
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(result.name)
                
                if let artists = result.artists {
                    Spacer()
                        .frame(height: detailsSpacing)
                    
                    Text(artists.joined(separator: ", "))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .frame(height: coverSize)
            .font(.footnote)
            
            Spacer()
        }
        .padding(boxPadding)
        .background(
            RoundedRectangle(cornerRadius: boxCornerRadius)
                .fill(Color.gray.opacity(boxBackgroundOpacity))
        )
    }
}

struct SearchView: View {
    @State var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.results, id: \.id) { result in
                        SearchResultView(result: result)
                            .onAppear {
                                if result.id == viewModel.results.last?.id {
                                    Task {
                                        await viewModel.fetchResults()
                                    }
                                }
                            }
                    }
                }
                .navigationTitle("Search")
                .searchable(text: $viewModel.query)
                .searchScopes($viewModel.segment) {
                    Text("Albums").tag(SearchSegment.Albums)
                    Text("Artists").tag(SearchSegment.Artists)
                    Text("Tracks").tag(SearchSegment.Tracks)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
