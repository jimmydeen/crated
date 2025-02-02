import SwiftUI

struct ProfileEditView: View {
    var body: some View {
        Text("Edit")
    }
}

struct ProfileEditViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
            .environment(Authentication())
            .previewDisplayName("Profile - Edit (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ProfileEditView()
            .environment(Authentication())
            .previewDisplayName("Profile - Edit (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
