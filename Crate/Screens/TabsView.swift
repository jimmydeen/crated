import SwiftUI

enum Tab {
    case home, search, activity, profile
}

struct TabsView: View {
    @State private var tab: Tab = .home
    @State private var isReviewing: Bool = false
    
    @State private var homeView = HomeView()
    @State private var searchView = SearchView()
    @State private var activityView = ActivityView()
    @State private var profileView = ProfileView()
    
    private let navBarButtonHeight: CGFloat = UIScreen.main.bounds.height * 0.06
    private let navBarButtonWidth: CGFloat = UIScreen.main.bounds.width * 0.15
    
    var body: some View {
        ZStack {
            VStack {
                switch tab {
                    case .home: homeView
                    case .search: searchView
                    case .activity: activityView
                    case .profile: profileView
                }
                
                HStack {
                    navButton(icon: "house.fill") { tab = .home }
                    navButton(icon: "magnifyingglass") { tab = .search }
                    navButton(icon: "plus.circle.fill") { isReviewing = true }
                    navButton(icon: "list.bullet.rectangle.fill") { tab = .activity }
                    navButton(icon: "person.crop.circle.fill") { tab = .profile }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.white)
            }
            
            if isReviewing {
                ZStack {
                    BackgroundBlurView()
                        .onTapGesture {
                            isReviewing = false
                        }
                        .ignoresSafeArea(.all)
                    
                    AddReviewView()
                        .ignoresSafeArea(.all)
                }
            }
        }
    }
    
    private func navButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title)
                .frame(width: navBarButtonWidth, height: navBarButtonHeight)
                .foregroundColor(.black)
        }
    }
}

struct TabsViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(UserViewModel())
    }
}
