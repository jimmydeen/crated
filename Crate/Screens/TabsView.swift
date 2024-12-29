import SwiftUI

public enum Tab: String, CaseIterable {
    case home
    case search
    case activity
    case profile
}

struct TabsView: View {
    @Environment(CommonDisplayViewModel.self) private var displayViewModel
    @State private var isShowingBackgroundBlur: Bool = false
    @State private var isShowingReview: Bool = false
    @State private var selectedTab: Tab = .home
    
    private let paddingBottom: CGFloat = 32
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch selectedTab {
                    case .home: HomeView(isShowingBackgroundBlur: $isShowingBackgroundBlur)
                    case .search: SearchView()
                    case .activity: ActivityView()
                    case .profile: ProfileView()
                }
                
                TabBarView(
                    isShowingBackgroundBlur: $isShowingBackgroundBlur,
                    isShowingReview: $isShowingReview,
                    selectedTab: $selectedTab
                )
                .background(Color.white)
                .disabled(!self.displayViewModel.isDisplayingNavigation)
                .foregroundColor(.black)
                .font(.title)
                .frame(maxWidth: .infinity)
                .opacity(self.displayViewModel.isDisplayingNavigation ? 1 : 0)
                .padding(.bottom, self.paddingBottom)
            }
        
            if self.isShowingBackgroundBlur {
                CommonBackgroundBlur()
                    .onTapGesture {
                        self.isShowingBackgroundBlur = false
                    }
                    .zIndex(1)
            }
            
            if self.isShowingReview {
                ReviewView()
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
            
            if self.displayViewModel.isDisplayingSignIn {
                SignInView()
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
    }
}

struct TabBarView: View {
    @Binding var isShowingBackgroundBlur: Bool
    @Binding var isShowingReview: Bool
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            TabBarButtonView(imageName: "house.fill") { self.selectedTab = Tab.home }
            TabBarButtonView(imageName: "magnifyingglass") { self.selectedTab = Tab.search }
            TabBarButtonView(imageName: "plus.circle") {
                withAnimation {
                    self.isShowingBackgroundBlur = true
                    self.isShowingReview = true
                }
            }
            TabBarButtonView(imageName: "list.bullet.rectangle.fill") { self.selectedTab = Tab.activity }
            TabBarButtonView(imageName: "person.crop.circle.fill") { self.selectedTab = Tab.profile }
        }
    }
}

struct TabBarButtonView: View {
    let imageName: String
    let action: () -> Void
    
    private let buttonHeight: CGFloat = UIScreen.main.bounds.height * 0.06
    private let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.15
    
    var body: some View {
        Button(action: { self.action() } ) {
            Image(systemName: self.imageName)
                .frame(width: self.buttonWidth, height: self.buttonHeight)
        }
    }
}

struct TabsViewPreview: PreviewProvider {
    static var displayViewModel = CommonDisplayViewModel()
    static var userViewModel = CommonUserViewModel(
        context: PersistenceController.shared.container.viewContext
    )
    
    static var previews: some View {
        TabsView()
            .environment(displayViewModel)
            .environment(userViewModel)
            .ignoresSafeArea(.all)
    }
}
