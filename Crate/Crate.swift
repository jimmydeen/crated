import SwiftUI
import Supabase

@main
struct CrateApp: App {
    @State private var userViewModel = CommonUserViewModel(context: PersistenceController.context)
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
