import SwiftUI

struct ProfileTabHistoryView: View {
    var body: some View {
        Text("Profile History")
    }
}

struct ProfileHistoryViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
