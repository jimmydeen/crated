import SwiftUI

struct CreateCrateItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: CreateCrateViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.standard.rawValue) {
            Title(text: "Add Albums To Crate")
            
            RoundedTextField(text: $viewModel.search.query, placeholder: "Search")
            
            results
        }
        .onChange(of: viewModel.search.query) {
            viewModel.search.search()
        }
        .padding([.horizontal, .top], .standard)
    }
    
    var results: some View {
        List(viewModel.search.results, id: \.id) { result in
            Button(action: {
                viewModel.addAlbum(album: result)
                dismiss()
            }) {
                ResultListRowView(result: result)
                    .onAppear {
                        viewModel.search.load(currentItem: result)
                    }
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct AddCrateItemViewPreviews: PreviewProvider {
    static var previews: some View {
        CreateCrateItemView(viewModel: CreateCrateViewModel())
            .environment(Authentication())
            .previewDisplayName("Add Crate Item (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        CreateCrateItemView(viewModel: CreateCrateViewModel())
            .environment(Authentication())
            .previewDisplayName("Add Crate Item (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
