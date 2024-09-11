import SwiftUI

public enum Tab: String, CaseIterable {
    case Home
    case Search
    case Activity
    case Profile
}

struct ContentView: View {
    @State private var selectedTab: Tab = Tab.Home
    @State private var isShowingReview: Bool = false
    
    private let tabBarPaddingBottom: CGFloat = 32
    private let tabButtonHeight: CGFloat = UIScreen.main.bounds.height * 0.06
    private let tabButtonWidth: CGFloat = UIScreen.main.bounds.width * 0.15
    
    var body: some View {
        ZStack {
            VStack {
                switch selectedTab {
                    case .Home: HomeView()
                    case .Search: SearchView()
                    case .Activity: ActivityView()
                    case .Profile: ProfileView()
                }
                
                HStack {
                    Button(action: { self.selectedTab = Tab.Home } ) {
                        Image(systemName: "house.fill")
                            .frame(width: self.tabButtonWidth, height: self.tabButtonHeight)
                    }
                    
                    Button(action: { self.selectedTab = Tab.Search } ) {
                        Image(systemName: "magnifyingglass")
                            .frame(width: self.tabButtonWidth, height: self.tabButtonHeight)
                    }
                    
                    Button(action: { withAnimation { self.isShowingReview.toggle() } } ) {
                        Image(systemName: "plus.circle")
                            .frame(width: self.tabButtonWidth, height: self.tabButtonHeight)
                    }
                    
                    Button(action: { self.selectedTab = Tab.Activity } ) {
                        Image(systemName: "bell.fill")
                            .frame(width: self.tabButtonWidth, height: self.tabButtonHeight)
                    }
                    
                    Button(action: { self.selectedTab = Tab.Profile } ) {
                        Image(systemName: "person.crop.circle.fill")
                            .frame(width: self.tabButtonWidth, height: self.tabButtonHeight)
                    }
                }
                .background(Color.white)
                .font(.title)
                .foregroundColor(.black)
                .padding(.bottom, tabBarPaddingBottom)
            }
            .zIndex(0)
            
            if self.isShowingReview {
                CommonDarkeningBlur()
                    .onTapGesture {
                        withAnimation {
                            isShowingReview.toggle()
                        }
                    }
                    .zIndex(1)
                
                ReviewView()
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
        
        ContentView()
            .environment(userViewModel)
    }
}
