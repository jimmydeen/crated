import SwiftUI

struct ProfileFriendsView: View {
    @Binding var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Title(text: "Friends")
            
            if viewModel.friends.isEmpty {
                EmptyMessageView(text: "No friends just yet.")
            } else {
                friends
            }
        }
        .padding([.horizontal, .top], .standard)
    }
    
    var friends: some View {
        List(viewModel.friends, id: \.id) { friend in
            ResultListRowView(result: friend)
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct ProfileFriendsViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Profile - Friends (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Profile - Friends (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
