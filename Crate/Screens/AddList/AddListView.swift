import SwiftUI
import PhotosUI

struct AddListView: View {
    @State var viewModel = AddListViewModel()
    @State private var name: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("List Details")) {
                TextField("Name", text: $viewModel.name)
                
                Button(action: {}) {
                    Text("Add Cover")
                }
            }
            
            Section {
                Button(action: {}) {
                    Text("Save")
                }
                .disabled(viewModel.name.isEmpty)
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
