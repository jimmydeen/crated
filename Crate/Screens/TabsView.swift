import SwiftUI

struct TabsView: View {
    @Environment(DisplayViewModel.self) private var displayViewModel
    
    @State private var tab: Tab = .home
    @State private var isReviewing: Bool = false
    
    @State private var homeView = HomeView()
    @State private var searchView = SearchView()
    @State private var activityView = ActivityView()
    @State private var profileView = ProfileView()
    
    private let navBarHeight: CGFloat = UIScreen.main.bounds.height * 0.08
    private let navBarPaddingHorizontal: CGFloat = 32
    
    var body: some View {
        ZStack {
            VStack {
                switch tab {
                    case .home: homeView
                    case .search: searchView
                    case .activity: activityView
                    case .profile: profileView
                }
                
                if displayViewModel.isShowingNavBar {
                    HStack {
                        navButton(icon: "house.fill") { tab = .home }
                        Spacer()
                        navButton(icon: "magnifyingglass") { tab = .search }
                        Spacer()
                        navButton(icon: "plus.circle.fill") { isReviewing = true }
                        Spacer()
                        navButton(icon: "list.bullet.rectangle.fill") { tab = .activity }
                        Spacer()
                        navButton(icon: "person.crop.circle.fill") { tab = .profile }
                    }
                    .padding(.horizontal, navBarPaddingHorizontal)
                }
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
                .foregroundColor(.black)
        }
    }
    
    private enum Tab {
        case home, search, activity, profile
    }
}

struct TabsViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(DisplayViewModel())
    }
}
