import SwiftUI

struct ProfileTabHeaderView: View {
    @Binding var currentTab: ProfileTab
    
    var body: some View {
        HStack(spacing: 12) {
            VStack {
                if currentTab != ProfileTab.Favorites {
                    Spacer()
                }
                
                Divider()
                
                if currentTab == ProfileTab.Favorites {
                    Spacer()
                }
            }
            
            VStack {
                if currentTab != ProfileTab.History {
                    Spacer()
                }
                
                Divider()
                
                if currentTab == ProfileTab.History {
                    Spacer()
                }
            }
            
            VStack {
                if currentTab != ProfileTab.ListeningStats {
                    Spacer()
                }
                
                Divider()
                
                if currentTab == ProfileTab.ListeningStats {
                    Spacer()
                }
            }
        }
    }
}

struct ProfileTabHeaderViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
