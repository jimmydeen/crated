import SwiftUI
import Kingfisher

struct SearchView: View {
    @Environment(DisplayViewModel.self) private var displayViewModel
    
    @FocusState private var isSearching: Bool
    
    @State var viewModel = SearchViewModel()
    
    private let searchBarCornerRadius: CGFloat = 6
    private let searchBarPaddingHorizontal: CGFloat = 12
    private let searchBarPaddingVertical: CGFloat = 6
    private let searchSpacing: CGFloat = 12
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, searchSpacing)
                
                TextField("Search", text: $viewModel.query)
                    .padding(.horizontal, searchBarPaddingHorizontal)
                    .padding(.vertical, searchBarPaddingVertical)
                    .background(Color.lightGray)
                    .cornerRadius(searchBarCornerRadius)
                    .autocorrectionDisabled()
                    .focused($isSearching)
                    .textInputAutocapitalization(.never)
                    .padding(.bottom, searchSpacing)
                
                if !viewModel.query.isEmpty {
                    picker
                }
                
                ZStack {
                    results
                    
                    VStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .white, .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 18)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .onChange(of: viewModel.query) {
                viewModel.search()
            }
            .onChange(of: viewModel.segment) {
                viewModel.search()
            }
            .onChange(of: isSearching) { visibility, _ in
                displayViewModel.isShowingNavBar = visibility
            }
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearching = false
                    }
            )
        }
    }
    
    var picker: some View {
        Picker("Search Segment", selection: $viewModel.segment) {
            ForEach(SearchSegment.allCases) { segment in
                Text("\(segment.rawValue.capitalized)s").tag(segment)
            }
        }
        .pickerStyle(.segmented)
    }

    var results: some View {
        List(viewModel.results, id: \.id) { result in
            SearchResultView(result: result, navigationView: result.searchView())
                .listRowInsets(
                    EdgeInsets(
                        top: 0,
                        leading: 0,
                        bottom: 0,
                        trailing: 12
                    )
                )
                .listRowSeparator(.hidden)
                .onAppear {
                    viewModel.loadMoreResults(currentItem: result)
                }
        }
        .padding(.top, 6)
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct SearchResultView: View {
    let result: SearchResult
    let navigationView: AnyView
    
    private let resultCoverSize: CGFloat = 48
    private let resultInnerPadding: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: navigationView) {
                HStack(alignment: .center, spacing: resultInnerPadding) {
                    KFImage(result.cover_hq)
                        .resizable()
                        .placeholder {
                            PlaceholderView()
                        }
                        .frame(width: resultCoverSize)
                    
                    VStack(alignment: .leading) {
                        Text(result.name)
                            .font(.callout)
                            .lineLimit(1)
                        
                        if !result.subtitle.isEmpty {
                            Text(result.subtitle)
                                .foregroundColor(.gray)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: resultCoverSize)
                .padding(resultInnerPadding)
            }
            
            Divider()
        }
    }
}

struct SearchViewPreview: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(DisplayViewModel())
    }
}
