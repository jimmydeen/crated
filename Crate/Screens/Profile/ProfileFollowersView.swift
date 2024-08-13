import SwiftUI

struct ProfileFollowersView: View {
    var body: some View {
        Text("Profile followers")
    }
}

struct ProfileFollowersViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
