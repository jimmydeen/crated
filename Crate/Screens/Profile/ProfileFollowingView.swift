import SwiftUI

struct ProfileFollowingView: View {
    var body: some View {
        Text("Profile following")
    }
}

struct ProfileFollowingViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
