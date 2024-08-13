import SwiftUI

struct ProfileTabListeningStatsView: View {
    var body: some View {
        Text("Profile Listening Stats")
    }
}

struct ProfileListeningStatsViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
