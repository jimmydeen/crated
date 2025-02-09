import SwiftUI
import Kingfisher

struct ProfileView: View {
    @Environment(Authentication.self) private var auth
    
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            if auth.isLoggedIn {
                VStack {
                    if viewModel.isUserLoaded, let profile = viewModel.profile {
                        if let avatar = profile.cover {
                            KFImage(avatar)
                                .boxSize(.standard)
                                .clipShape(Circle())
                        } else {
                            PlaceholderProfilePictureView()
                                .boxSize(.standard)
                                .clipShape(Circle())
                                .font(.largeTitle)
                        }
                        
                        Text("@\(profile.username)")
                            .font(.title3)
                    }
                    
                    RoundedNavButton(text: "Edit Profile", destination: ProfileEditView())
                    
                    RoundedNavButton(text: "Friends", destination: ProfileFriendsView(viewModel: $viewModel))
                        .padding(.bottom, .standard)
                    
                    RoundedNavButton(text: "Crates", destination: CratesView())
                    
                    RoundedNavButton(text: "Favorites", destination: FavoritesView())
                    
                    RoundedNavButton(text: "Reviews", destination: ReviewsView())
                    
                    Spacer()
                }
                .padding(.standard)
                .task {
                    await viewModel.fetchUser()
                }
            } else {
                SignInPrompt(text: "Sign in to see your profile")
            }
        }
    }
}

struct ProfileViewPreviews: PreviewProvider {
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
