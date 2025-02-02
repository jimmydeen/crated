import SwiftUI
import Kingfisher

struct CratesView: View {
    @State var viewModel = CratesViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Title(text: "Crates")
                
                Spacer()
                
                NavigationLink(destination: CreateCrateView()) {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundColor(.blue)
                }
            }
            
            if viewModel.crates.isEmpty {
                EmptyMessageView(text: "No crates just yet.")
            } else {
                crates
            }
        }
        .padding([.horizontal, .top], .standard)
        .task {
            await viewModel.fetchCrates()
        }
    }
    
    var crates: some View {
        List(viewModel.crates, id: \.id) { crate in
            NavigationLink(destination: CrateView(viewModel: CrateViewModel(crate: crate))) {
                ResultListRowView(result: crate)
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct CratesViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Crate (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Crate (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
