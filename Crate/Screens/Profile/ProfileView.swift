import SwiftUI

enum ProfileTab: String, CaseIterable {
    case Favorites = "person.fill"
    case History = "clock"
    case ListeningStats = "chart.bar.fill"
}

struct ProfileView: View {
    @Environment(SharedUserViewModel.self) private var userViewModel
    @State var viewModel: ProfileViewModel = ProfileViewModel()
    @State var currentTab: ProfileTab = ProfileTab.Favorites
    
    private let detailsVerticalFrameSize: CGFloat = UIScreen.main.bounds.height * 0.08
    private let elementWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    private let pagePaddingTop: CGFloat = UIScreen.main.bounds.height * 0.06
    private let profileDetailsElementSpacing: CGFloat = 0
    private let profileDetailsPaddingHorizontal: CGFloat = 30
    private let profilePictureCameraIconPaddingBottom: CGFloat = 12
    private let profilePictureImageSize: CGFloat = UIScreen.main.bounds.height * 0.1
    private let profileSpacingFromPicture: CGFloat = 20
    private let tabFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.3
    private let tabPickerFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.05
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: pagePaddingTop)
                
                HStack(alignment: .center, spacing: profileSpacingFromPicture) {
                    NavigationLink(destination: ProfilePictureEditorView(viewModel: $viewModel)) {
                        ZStack {
                            Rectangle()
                                .fill(Colors.placeholderGray)
                            
                            LinearGradient(
                                colors: [.clear, .gray],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                            
                            VStack {
                                Spacer()
                                
                                Image(systemName: "camera.fill")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding(.bottom, profilePictureCameraIconPaddingBottom)
                            }
                        }
                        .clipShape(Circle())
                        .frame(width: profilePictureImageSize)
                    }
                    
                    VStack(alignment: .leading, spacing: profileDetailsElementSpacing) {
                        Text(userViewModel.user.user_displayname)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("@\(userViewModel.user.user_name)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack {
                            NavigationLink(destination: ProfileFollowersView()) {
                                Text(String(userViewModel.user.user_follower_count))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black) +
                                
                                Text(" followers")
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: ProfileFollowingView()) {
                                Text(String(userViewModel.user.user_following_count))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black) +
                                
                                Text(" following")
                                    .foregroundColor(.gray)
                            }
                        }
                        .font(.footnote)
                        .padding(.horizontal, 2)
                    }
                    .frame(height: detailsVerticalFrameSize)
                }
                .frame(width: elementWidth, height: profilePictureImageSize)
                
                ZStack {
                    HStack(spacing: 12) {
                        ForEach(ProfileTab.allCases, id: \.self) { tab in
                            HStack {
                                Image(systemName: tab.rawValue)
                                    .foregroundColor(tabHeaderColor(forTab: tab))
                            }
                            .frame(width: tabHeaderHitBoxWidth - 8, height: tabPickerFrameHeight)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentTab = tab
                            }
                        }
                    }
                    
//                    ProfileTabHeaderView(currentTab: $currentTab)
//                        .frame(width: elementWidth, height: tabPickerFrameHeight)
                }
                
                tabContentsToDisplay(forTab: currentTab)
                    .frame(width: elementWidth)
                
                Spacer()
            }
        }
    }
    
    private var tabHeaderHitBoxWidth: CGFloat {
        return elementWidth / CGFloat(ProfileTab.allCases.count)
    }
    
    private func tabHeaderColor(forTab tab: ProfileTab) -> Color {
        if tab == currentTab {
            return Color.black
        } else {
            return Colors.placeholderGray
        }
    }
    @ViewBuilder private func tabContentsToDisplay(forTab tab: ProfileTab) -> some View {
        switch tab {
            case .Favorites: ProfileTabFavoritesGridView(viewModel: $viewModel)
            case .History: ProfileTabHistoryView()
            case .ListeningStats: ProfileTabListeningStatsView()
        }
    }
}

struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ProfileView()
            .environment(userViewModel)
    }
}
