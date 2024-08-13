import SwiftUI

struct ProfilePictureEditorView: View {
    @Binding var viewModel: ProfileViewModel
    
    var body: some View {
        Text("Profile picture editor")
    }
}

struct ProfiePictureEditorViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
