import SwiftUI
import PhotosUI

struct CreateCrateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = CreateCrateViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Title(text: "New Crate")
            
            RoundedTextField(text: $viewModel.name, placeholder: "Name")
            
            RoundedNavButton(text: "Add Albums", destination: CreateCrateItemView(viewModel: viewModel))
            
            RoundedButton(text: "Save Crate", action: {
                viewModel.createCrate()
                dismiss()
            })
            .disabled(viewModel.name.isEmpty)
            
            List(viewModel.albums) { album in
                ResultListRowView(result: album)
            }
            .listStyle(.inset)
            .scrollIndicators(.hidden)
            
            Spacer()
        }
        .padding(.standard)
    }
}

struct AddCrateViewPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateCrateView()
        }
        .environment(Authentication())
        .previewDisplayName("Add Crate (Signed Out)")
        .onAppear { Test.ensureSignedOut() }
        
        NavigationStack {
            CreateCrateView()
                .task { await Test.signInToTestAccount() }
        }
        .environment(Authentication())
        .previewDisplayName("Add Crate (Signed In)")
    }
}
