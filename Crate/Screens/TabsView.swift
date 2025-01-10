import SwiftUI

fileprivate enum Tab {
    case home, search, activity, profile
}

struct TabsView: View {
    @State private var tab: Tab = .home
    @State private var isShowingReviewPopUp: Bool = false
    
    private let navBarButtonHeight: CGFloat = UIScreen.main.bounds.height * 0.06
    private let navBarButtonWidth: CGFloat = UIScreen.main.bounds.width * 0.15
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch tab {
                    case .home: HomeView()
                    case .search: SearchView()
                    case .activity: ActivityView()
                    case .profile: ProfileView()
                }
                
                HStack {
                    navBarButton(icon: "house.fill") { tab = Tab.home }
                    navBarButton(icon: "magnifyingglass") { tab = Tab.search }
                    navBarButton(icon: "plus.circle") { isShowingReviewPopUp = true }
                    navBarButton(icon: "list.bullet.rectangle.fill") { tab = Tab.activity }
                    navBarButton(icon: "person.crop.circle.fill") { tab = Tab.profile }
                }
                .font(.title)
                .foregroundColor(.black)
            }
        
            if isShowingReviewPopUp {
                BackgroundBlurView()
                    .onTapGesture {
                        isShowingReviewPopUp = false
                    }
                
                ReviewView()
            }
        }
    }
    
    private func navBarButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: { action() } ) {
            Image(systemName: icon)
                .frame(width: navBarButtonWidth, height: navBarButtonHeight)
        }
    }
}

struct TabsViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
