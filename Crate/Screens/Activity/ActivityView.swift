import SwiftUI

struct ActivityView: View {
    @Environment(Authentication.self) private var auth
    
    @State var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            if auth.isLoggedIn {
                VStack(alignment: .leading) {
                    Title(text: "Activity")
                    
                    if viewModel.activities.isEmpty {
                        EmptyMessageView(text: "No activity just yet.")
                    } else {
                        List(viewModel.activities) {  activity in
                            Text(activity.description)
                        }
                        .listStyle(.inset)
                        .scrollIndicators(.hidden)
                    }
                    
                    Spacer()
                }
                .padding(.standard)
                .task {
                    await viewModel.fetchActivities()
                }
            } else {
                SignInPrompt(text: "Sign in to see your activity")
            }
        }
    }
}

struct ActivityViewPreviews: PreviewProvider {
    static var previews: some View {
        ActivityView()
            .environment(Authentication())
            .previewDisplayName("Activity (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        ActivityView()
            .environment(Authentication())
            .previewDisplayName("Activity (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
