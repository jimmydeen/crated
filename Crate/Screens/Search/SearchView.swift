import SwiftUI
import Kingfisher

struct SearchView: View {
    @Environment(Authentication.self) private var auth
    
    @State var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Spacing.standard.rawValue) {
                Title(text: "Search")
                
                RoundedTextField(text: $viewModel.search.query, placeholder: "Search")
                
                if !viewModel.search.query.isEmpty {
                    if auth.isLoggedIn {
                        picker(tabs: SearchSegment.allCases)
                    } else {
                        picker(tabs: [.album, .artist, .track])
                    }
                }
                
                results
            }
            .padding([.horizontal, .top], .standard)
        }
        .onChange(of: viewModel.search.query) {
            viewModel.search.search()
        }
        .onChange(of: viewModel.search.segment) {
            viewModel.search.search()
        }
    }
    
    func picker(tabs: [SearchSegment]) -> some View {
        Picker("Search Segment", selection: $viewModel.search.segment) {
            ForEach(tabs) { segment in
                Text("\(segment.rawValue.capitalized)s").tag(segment)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var results: some View {
        List(viewModel.search.results, id: \.id) { result in
            NavigationLink(destination: result.searchView()) {
                ResultListRowView(result: result)
                    .onAppear {
                        viewModel.search.load(currentItem: result)
                    }
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct SearchViewPreviews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(Authentication())
            .previewDisplayName("Search (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        SearchView()
            .environment(Authentication())
            .previewDisplayName("Search (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
