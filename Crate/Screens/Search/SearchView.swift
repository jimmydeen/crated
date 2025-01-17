import SwiftUI
import Kingfisher

struct SearchView: View {
    @State var viewModel = SearchViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    private let coverSize: CGFloat = 48
    private let coverToDetailsSpacing: CGFloat = 12
    private let detailsLineSpacing: CGFloat = 6
    private let resultBoxCornerRadius: CGFloat = 8
    private let resultBoxPadding: CGFloat = 8
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    // Custom Search Bar
                  HStack {
                      TextField("Search", text: $viewModel.query)
                          .padding(.vertical, 8)
                          .padding(.horizontal)
                          .focused($isSearchFieldFocused)
                          .background(Color(.systemGray6))
                          .cornerRadius(8)
                  }
                  .padding(.horizontal, 2)
                    picker
                    results
                }
                .padding(.horizontal)
                .navigationTitle("Search")
                
            }
            .dismissKeyboardOnInteraction(tap: true, swipe: true)
        }
    }
    
    var picker: some View {
        Picker("Search Segment", selection: $viewModel.segment) {
            Text("Albums").tag(SearchViewModel.SearchSegment.album)
            Text("Artists").tag(SearchViewModel.SearchSegment.artist)
            Text("Tracks").tag(SearchViewModel.SearchSegment.track)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var results: some View {
        ForEach(Array(viewModel.results.enumerated()), id: \.offset) { index, result in
            if !viewModel.results.isEmpty, index > 0, index % 20 == 0 {
                searchResult(result: result)
                    .task {
                        await viewModel.fetchResults()
                    }
            } else {
                searchResult(result: result)
            }
        }
    }
    
    func searchResult(result: ResultProtocol) -> some View {
        NavigationLink(destination: result.searchView()) {
            HStack(alignment: .center) {
                KFImage(result.cover_hq)
                    .resizable()
                    .placeholder {
                        PlaceholderView()
                    }
                    .frame(width: coverSize, height: coverSize)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(result.name)
                    
                    if !result.artists.isEmpty {
                        Spacer()
                            .frame(height: detailsLineSpacing)
                        
                        Text(result.artists.joined(separator: ", "))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .frame(height: coverSize)
                .font(.subheadline)
                
                Spacer()
            }
            .padding(resultBoxPadding)
            .background(Color.lightGray)
            .cornerRadius(resultBoxCornerRadius)
        }
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(UserViewModel())
    }
}
