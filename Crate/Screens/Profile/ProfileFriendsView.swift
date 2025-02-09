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
        .task {
            await viewModel.loadInitialFriends()
        }
    }
    
    var friends: some View {
        List(viewModel.friends, id: \.id) { friend in
            NavigationLink(destination: friend.searchView()){
                Text(friend.name)
            }
        }
        .listStyle(.inset)
        .scrollIndicators(.hidden)
    }
}

struct ProfileFriendsViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Profile (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ProfileView()
            .environment(Authentication())
            .previewDisplayName("Profile (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
