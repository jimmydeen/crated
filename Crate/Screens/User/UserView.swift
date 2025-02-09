import SwiftUI
import Kingfisher

struct UserView: View {
    @State var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            if viewModel.profile.avatar != nil {
                KFImage(URL(string: viewModel.profile.avatar!)!)
                    .boxSize(.standard)
                    .clipShape(Circle())
            } else {
                PlaceholderProfilePictureView()
                    .boxSize(.standard)
            }
            
            Text("@\(viewModel.profile.username)")
                .font(.title2)
            
            RoundedButton(text: "Send friend request", action: { viewModel.sendFriendRequest() })
        }
        .padding(.standard)
    }
}

struct UserViewPreviews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: UserViewModel(profile: Test.user))
            .environment(Authentication())
            .previewDisplayName("User (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        UserView(viewModel: UserViewModel(profile: Test.user))
            .environment(Authentication())
            .previewDisplayName("User (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
