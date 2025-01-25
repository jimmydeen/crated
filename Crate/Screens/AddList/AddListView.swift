import SwiftUI
import PhotosUI

struct AddListView: View {
    @State var viewModel = AddListViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("List Details")) {
                TextField("Name", text: $viewModel.name)
                
                Button(action: {}) {
                    Text("Add Cover")
                }
            }
            
            NavigationLink(destination: AddListItemView(viewModel: viewModel)) {
                Text("Add albums to list")
                    .foregroundColor(.black)
            }
            
            Section {
                Button(action: {}) {
                    Text("Save")
                }
                .disabled(viewModel.name.isEmpty)
                .disabled(viewModel.albums.isEmpty)
            }
        }
        .navigationTitle("New List")
    }
}

struct AddListViewPreview: PreviewProvider {
    static var previews: some View {
        AddListView()
            .environment(DisplayViewModel())
    }
}
