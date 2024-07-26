import SwiftUI

struct AddView: View {
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
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
                }
            }
            .navigationTitle("Add Album")
            .searchable(text: $viewModel.query)
        }
    }
}

struct AddItemViewPreview: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
