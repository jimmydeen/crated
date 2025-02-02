import SwiftUI

struct CrateAddView: View {
    @Binding var viewModel: CrateViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Title(text: "Add To List")
            
            RoundedTextField(text: $viewModel.search.query, placeholder: "Search")
            
            results
        }
    }
    
    var results: some View {
        List(viewModel.search.results, id: \.id) { album in
            Button(action: {
                viewModel.addAlbum(album: album)
                dismiss()
            }) {
                ResultListRowView(result: album)
                    .onAppear { viewModel.search.load(currentItem: album) }
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct CrateAddViewPreviews: PreviewProvider {
    static var previews: some View {
        CrateView(viewModel: CrateViewModel(crate: Test.crate))
            .environment(Authentication())
            .previewDisplayName("Crate (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        CrateView(viewModel: CrateViewModel(crate: Test.crate))
            .environment(Authentication())
            .previewDisplayName("Crate (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
