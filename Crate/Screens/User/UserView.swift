import SwiftUI
import Kingfisher

struct UserView: View {
    @State var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            if viewModel.user.avatar != nil {
                KFImage(URL(string: viewModel.user.avatar!)!)
                    .boxSize(.standard)
                    .clipShape(Circle())
            } else {
                PlaceholderProfilePictureView()
                    .boxSize(.standard)
            }
            
            Text("@\(viewModel.user.username)")
                .font(.title2)
        }
    }
}

struct UserViewPreviews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: UserViewModel(user: Test.user))
            .environment(Authentication())
            .previewDisplayName("User (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        UserView(viewModel: UserViewModel(user: Test.user))
            .environment(Authentication())
            .previewDisplayName("User (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
