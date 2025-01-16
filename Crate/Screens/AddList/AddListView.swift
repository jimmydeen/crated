import SwiftUI

struct AddListView: View {
    @State private var name: String = ""
    @State private var coverURL: String = ""
    @State private var albums: String = "" // Comma-separated album IDs
    @Environment(\.dismiss) private var dismiss
    
    var onSave: (ListModel) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("List Details")) {
                TextField("Name", text: $name)
                
                TextField("Cover URL", text: $coverURL)
                    .keyboardType(.URL)
                
                TextField("Albums (comma-separated)", text: $albums)
            }
            
            Section {
                Button(action: saveList) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .disabled(name.isEmpty || albums.isEmpty)
            }
        }
        .navigationTitle("New List")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func saveList() {
        let albumList = albums
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        let list = ListModel(
            name: name,
            user_id: UUID().uuidString, // Replace with the real user ID
            cover: URL(string: coverURL),
            albums: albumList,
            id: UUID().uuidString
        )
        
        onSave(list)
        dismiss()
    }
}

struct AddListViewPreview: PreviewProvider {
    static var previews: some View {
        AddListView()
    }
}
