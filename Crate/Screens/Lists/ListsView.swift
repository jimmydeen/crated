import SwiftUI
import Kingfisher

struct ListsView: View {
    @State var viewModel: ListsViewModel
    
    var body: some View {
        VStack {
            if !viewModel.lists.isEmpty {
                ForEach(viewModel.lists, id: \.id) { list in
                    NavigationLink(
                        destination: ListView(viewModel: ListViewModel(list: list))
                    ) {
                        HStack {
                            KFImage(list.cover)
                                .resizable()
                                .placeholder {
                                    PlaceholderView()
                                }
                            
                            Text(list.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Lists")
    }
}
