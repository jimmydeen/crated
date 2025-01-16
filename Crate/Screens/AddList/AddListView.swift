import SwiftUI

struct AddListView: View {
    @State var viewModel = AddListViewModel()
    @State private var name: String = ""
    @State private var coverURL: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("List Details")) {
                TextField("Name", text: $name)
            }
            
            Section {
                Button(action: {}) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .disabled(name.isEmpty)
            }
        }
        .navigationTitle("New List")
    }
}

struct AddListViewPreview: PreviewProvider {
    static var previews: some View {
        AddListView()
    }
}
