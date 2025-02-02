import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            
            CreateReviewView()
                .tabItem { Label("Create", systemImage: "plus.circle.fill") }
            
            ActivityView()
                .tabItem { Label("Activity", systemImage: "list.bullet.rectangle.fill") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
    }
}

struct TabsViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(Authentication())
            .previewDisplayName("Application (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        TabsView()
            .environment(Authentication())
            .previewDisplayName("Application (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
