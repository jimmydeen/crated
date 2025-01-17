import SwiftUI
import Kingfisher

struct SearchView: View {
    @State var viewModel = SearchViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    private let coverSize: CGFloat = 48
    private let detailsLineSpacing: CGFloat = 6
    private let resultBoxCornerRadius: CGFloat = 8
    private let resultBoxPadding: CGFloat = 8
    
    var body: some View {
        NavigationStack {
            // 1) Put your entire pinned header in a top VStack
            VStack(spacing: 0) {
                
                // 2) Custom “header” (title + search bar + picker)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Search")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    searchBar
                    picker
                }
                .padding()  // Adjust to match your desired spacing
                .background(Color(.systemBackground))
                
//                // 3) The divider (optional)
//                Divider()
//                
                // 4) Scrollable area with results
                ScrollView(showsIndicators: false) {
                    results
                        .padding(.horizontal)
                }
            }
            .onTapGesture {
                dismissKeyboard();
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true) // Hides the default navigation bar
        }
    }
    
    // MARK: - Search Bar
    var searchBar: some View {
        TextField("Search", text: $viewModel.query)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .focused($isSearchFieldFocused)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
    
    // MARK: - Picker
    var picker: some View {
        Picker("Search Segment", selection: $viewModel.segment) {
            Text("Albums").tag(SearchViewModel.SearchSegment.album)
            Text("Artists").tag(SearchViewModel.SearchSegment.artist)
            Text("Tracks").tag(SearchViewModel.SearchSegment.track)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Results
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
    
    // MARK: - Single Result
    func searchResult(result: ResultProtocol) -> some View {
        NavigationLink(destination: result.searchView()) {
            HStack(alignment: .center) {
                KFImage(result.cover_hq)
                    .resizable()
                    .placeholder {
                        PlaceholderView()
                    }
                    .frame(width: coverSize, height: coverSize)
                
                VStack(alignment: .leading, spacing: detailsLineSpacing) {
                    Text(result.name)
                        .font(.subheadline)
                    
                    if !result.artists.isEmpty {
                        Text(result.artists.joined(separator: ", "))
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
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
