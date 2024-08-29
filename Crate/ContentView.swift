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
    
    var body: some View {
        ZStack {
            VStack {
                switch self.selectedTab {
                case .Home:
                    HomeView()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height * 0.88
                        )
                case .Search:
                    SearchView()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height * 0.88
                        )
                case .Activity:
                    ActivityView()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height * 0.88
                        )
                case .Profile:
                    ProfileView()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height * 0.88
                        )
                }
                
                Spacer()
            }
            .zIndex(0)
            
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Button(
                            action: { self.selectedTab = Tab.Home },
                            label: {
                                Image(systemName: "opticaldisc")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.16,
                                        height: UIScreen.main.bounds.height * 0.08
                                    )
                            }
                        )
                        
                        Button(
                            action: { self.selectedTab = Tab.Search },
                            label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.16,
                                        height: UIScreen.main.bounds.height * 0.08
                                    )
                            }
                        )
                        
                        Button(
                            action: {
                                withAnimation {
                                    self.isShowingReview = true
                                }
                            },
                            label: {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.16,
                                        height: UIScreen.main.bounds.height * 0.08
                                    )
                            }
                        )
                        
                        Button(
                            action: { self.selectedTab = Tab.Activity },
                            label: {
                                Image(systemName: "quote.bubble")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.16,
                                        height: UIScreen.main.bounds.height * 0.08
                                    )
                            }
                        )
                        
                        Button(
                            action: { self.selectedTab = Tab.Profile },
                            label: {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.16,
                                        height: UIScreen.main.bounds.height * 0.08
                                    )
                            }
                        )
                    }
                    
                    Spacer()
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.12
                )
                .background(
                    Rectangle()
                        .fill(.white)
                )
            }
            .zIndex(1)
            
            if self.isShowingReview {
                ReviewView()
                    .transition(.move(edge: .bottom))
                    .zIndex(3)
                
                Color.black.opacity(0.4)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isShowingReview = false
                        }
                    }
                    .zIndex(2)
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ContentView()
            .environment(userViewModel)
    }
}
