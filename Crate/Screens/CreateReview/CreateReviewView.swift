import SwiftUI
import Kingfisher

struct CreateReviewView: View {
    @Environment(Authentication.self) private var auth
    
    @State var viewModel = CreateReviewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Spacing.standard.rawValue) {
                if auth.isLoggedIn {
                    switch viewModel.tab {
                        case .edit: editor
                        case .search: search
                    }
                } else {
                    SignInPrompt(text: "Sign in to create a review")
                }
            }
            .padding([.horizontal, .top], .standard)
        }
        .onChange(of: viewModel.search.query) {
            viewModel.search.search()
        }
    }
    
    var editor: some View {
        Group {
            ResultListRowView(result: viewModel.album!)
            
            RoundedTextField(text: $viewModel.title, placeholder: "Title")
            
            RoundedTextEditor(text: $viewModel.description, placeholder: "Description")
            
            RoundedButton(text: "Publish Review", action: { viewModel.publishReview() })
        }
    }
    
    var search: some View {
        Group {
            Title(text: "New Review")
            
            RoundedTextField(text: $viewModel.search.query, placeholder: "Search")
            
            results
        }
    }

    var results: some View {
        List(viewModel.search.results, id: \.id) { album in
            Button(action: { viewModel.selectAlbum(album: album) }) {
                ResultListRowView(result: album)
                    .onAppear {
                        viewModel.search.load(currentItem: album)
                    }
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct CreateReviewViewPreviews: PreviewProvider {
    static var previews: some View {
        CreateReviewView()
            .environment(Authentication())
            .previewDisplayName("Create Review (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        CreateReviewView()
            .environment(Authentication())
            .previewDisplayName("Create Review (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
