import SwiftUI

struct AddView: View {
    @State var viewModel = SearchViewModel()
    
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
                .navigationTitle("Add Album")
                .searchable(text: $viewModel.query)
                .padding(.horizontal)
            }
        }
    }
}

struct AddItemViewPreview: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
