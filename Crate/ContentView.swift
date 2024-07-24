import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Image(systemName: "opticaldisc") }
            SearchView().tabItem { Image(systemName: "magnifyingglass") }
            AddView().tabItem { Image(systemName: "plus.circle") }
            ActivityView().tabItem { Image(systemName: "quote.bubble") }
            ProfileView().tabItem { Image(systemName: "person.crop.circle.fill") }
        }
    }
}

struct ContentViewPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
