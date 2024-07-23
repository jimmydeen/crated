import SwiftUI

struct AddView: View {
    @StateObject private var viewModel = AddViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(Array(viewModel.albums.enumerated()), id: \.offset) { index, album in
                            SearchResultView(result: album)
                                .padding(.horizontal)
                                .onAppear {
                                    if loadsNextBatch(atIndex: index) {
                                        viewModel.fetchAlbums()
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
    
    private func loadsNextBatch(atIndex index: Int) -> Bool {
        return index == $viewModel.albums.count - 1
    }
}

struct AddItemViewPreview: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
