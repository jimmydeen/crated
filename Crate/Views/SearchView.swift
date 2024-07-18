import SwiftUI

public enum SearchSegment: String, CaseIterable {
    case Albums = "album"
    case Artists = "artist"
    case Tracks = "track"
}

struct SearchResultView: View {
    let result: IdentifiableProtocol
    
    private let boxPadding: CGFloat = 8
    private let coverSize: CGFloat = 60
    private let horizontalElementSpacing: CGFloat = 12
    private let innerElementSpacing: CGFloat = 6
    
    private let boxCornerRadius: CGFloat = 8
    private let coverCornerRadius: CGFloat = 4
    
    private let placeholderOpacity: CGFloat = 0.12
    
    var body: some View {
        HStack(alignment: .center, spacing: horizontalElementSpacing) {
            if result.image_cover_url_lq != nil {
                AsyncImage(url: URL(string: result.image_cover_url_lq!)) { phase in
                    phase.image?
                        .resizable()
                        .frame(width: coverSize, height: coverSize)
                        .clipShape(RoundedRectangle(cornerRadius: coverCornerRadius))
                }
            } else {
                RoundedRectangle(cornerRadius: coverCornerRadius)
                    .frame(width: coverSize, height: coverSize)
            }
            VStack(alignment: .leading) {
                Spacer()
                
                Text(result.name)
                    .font(.footnote)
                
                if result.artists != nil {
                    Spacer().frame(height: innerElementSpacing)
                    Text(result.artists!.joined(separator: ", "))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .frame(height: coverSize)
            
            Spacer()
        }
        .padding(boxPadding)
        .background(
            RoundedRectangle(cornerRadius: boxCornerRadius)
                .fill(Color.gray.opacity(placeholderOpacity))
        )
    }
}

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $searchViewModel.selectedSegment) {
                    Text("Albums").tag(SearchSegment.Albums)
                    Text("Artists").tag(SearchSegment.Artists)
                    Text("Tracks").tag(SearchSegment.Tracks)
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
                .onChange(of: searchViewModel.selectedSegment) {
                    searchViewModel.retrieveQuery(expansionQuery: false)
                }
                
                if searchViewModel.results.isEmpty {
                    
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(searchViewModel.results.indices, id: \.self) { index in
                                let result = searchViewModel.results[index]
                                if isLastResult(at: index) {
                                    SearchResultView(result: result)
                                        .onAppear {
                                            searchViewModel.retrieveQuery(expansionQuery: true)
                                        }
                                } else {
                                    SearchResultView(result: result)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .navigationTitle("Search")
        }
        .searchable(text: $searchViewModel.query)
    }
    
    private func isLastResult(at resultIndex: Int) -> Bool {
        return resultIndex == searchViewModel.results.count - 1
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
