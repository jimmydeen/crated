import SwiftUI

@main
struct CrateApp: App {
    @State private var userViewModel = SharedUserViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userViewModel)
        }
    }
}
