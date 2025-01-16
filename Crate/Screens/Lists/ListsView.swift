import SwiftUI
import Kingfisher

struct ListsView: View {
    @State var viewModel = ListsViewModel()
    
    var body: some View {
        VStack {
            if !viewModel.lists.isEmpty {
                ForEach(viewModel.lists, id: \.id) { list in
                    NavigationLink(destination: ListView(list: list)) {
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
            } else {
                VStack {
                    Spacer()
                    
                    Text("No lists just yet.")
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Lists")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddListView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ListsViewPreview: PreviewProvider {
    static var previews: some View {
        ListsView()
            .environment(UserViewModel())
    }
}
