import SwiftUI

struct AddItemView: View {
    @StateObject private var addItemViewModel = AddItemViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if addItemViewModel.results.isEmpty {
                    
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(addItemViewModel.results.indices, id: \.self) { index in
                                let album = addItemViewModel.results[index]
                                if isLastResult(at: index) {
                                    SearchResultView(result: album)
                                        .onAppear { addItemViewModel.refreshAlbums(for: album) }
                                } else {
                                    SearchResultView(result: album)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Album")
            .searchable(text: $addItemViewModel.query)
        }
    }
    
    private func isLastResult(at resultIndex: Int) -> Bool {
        return resultIndex == addItemViewModel.results.count - 1
    }
}
