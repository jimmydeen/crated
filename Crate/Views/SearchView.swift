import SwiftUI

public enum SearchSegment: String, CaseIterable {
    case Albums = "album"
    case Artists = "artist"
    case Tracks = "track"
}

struct SearchResultView: View {
    let result: IdentifiableProtocol
    
    private let boxCornerRadius: CGFloat = 8
    private let boxBackgroundOpacity: CGFloat = 0.1
    private let boxPadding: CGFloat = 8
    private let coverPlaceholderOpacity: CGFloat = 0.2
    private let coverSize: CGFloat = 60
    private let coverSpacingFromDetails: CGFloat = 12
    private let detailsSpacing: CGFloat = 6
    
    var body: some View {
        HStack(alignment: .center, spacing: coverSpacingFromDetails) {
            if result.image_cover_url_lq == nil {
                Rectangle()
                    .fill(.black.opacity(coverPlaceholderOpacity))
                    .frame(width: coverSize, height: coverSize)
            } else {
                AsyncImage(url: URL(string: result.image_cover_url_lq!)) { phase in
                    switch phase {
                        case .success(let image): image.resizable()
                        case .empty: Rectangle().fill(.black.opacity(coverPlaceholderOpacity))
                        case .failure: Rectangle().fill(.black.opacity(coverPlaceholderOpacity))
                        @unknown default: Rectangle().fill(.black.opacity(coverPlaceholderOpacity))
                    }
                }
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
    @State private var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(Array(viewModel.results.enumerated()), id: \.offset) { index, result in
                        SearchResultView(result: result)
                            .onAppear {
                                if isLastResult(atIndex: index) {
                                    Task {
                                        await viewModel.fetchResults()
                                    }
                                }
                            }
                    }
                }
                .searchable(text: $viewModel.query)
                .searchScopes($viewModel.segment) {
                    Text("Albums").tag(SearchSegment.Albums)
                    Text("Artists").tag(SearchSegment.Artists)
                    Text("Tracks").tag(SearchSegment.Tracks)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Search")
        }
    }
    
    private func isLastResult(atIndex index: Int) -> Bool {
        return index == viewModel.results.count - 1
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
