import SwiftUI
import Kingfisher

struct ProfileView: View {
    @Environment(UserViewModel.self) private var userViewModel
    
    private let cellSize: CGFloat = (UIScreen.main.bounds.width * 0.888) / 3
    private let detailsPaddingLeading: CGFloat = 2
    private let fullDetailsPaddingHorizontal: CGFloat = 36
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.028
    private let profilePicturePaddingTrailing: CGFloat = 10
    private let rowCellCount: Int = 3
    private let signInButtonPaddingHorizontal: CGFloat = 6
    private let signInButtonPaddingVertical: CGFloat = 12
    private let suburbOffsetX: CGFloat = -4
    private let suburbOffsetY: CGFloat = 1
    
    private let detailsButtonsPaddingLeading: CGFloat = 4
    private let detailsButtonsSpacing: CGFloat = 20
    private let detailsHeight: CGFloat = UIScreen.main.bounds.width * 0.216
    private let detailsWidth: CGFloat = UIScreen.main.bounds.width * 0.5
    private let detailsUsernamePaddingBottom: CGFloat = 2
    
    var body: some View {
        NavigationStack {
            if userViewModel.isAuthenticated, let user = userViewModel.currentUser {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("@\(user.name)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, detailsUsernamePaddingBottom)
                                
                                Spacer()
                                
                                HStack(spacing: detailsButtonsSpacing) {
                                    Button(
                                        action: { },
                                        label: {
                                            Text("Friends")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                                .underline()
                                        }
                                    )
                                    
                                    Button(
                                        action: { },
                                        label: {
                                            Text("Edit Profile")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                                .underline()
                                        }
                                    )
                                }
                                .padding(.leading, detailsButtonsPaddingLeading)
                            }
                            .frame(width: detailsWidth, height: detailsHeight)
                            
                            Spacer()
                            
                            KFImage(URL(string: (userViewModel.currentUser?.cover) ?? ""))
                                .resizable()
                                .placeholder {
                                    PlaceholderView()
                                }
                                .frame(width: detailsHeight)
                        }
                        .frame(height: detailsHeight)
                        .padding(.horizontal, fullDetailsPaddingHorizontal)
                        
                        NavigationLink(
                            destination: FavoritesView(viewModel: FavoritesViewModel(userViewModel: UserViewModel()))
                        ) {
                            HStack {
                                Text("Favorites")
                                
                                Spacer()
                            }
                        }
                        
                        NavigationLink(
                            destination: ListsView(viewModel: ListsViewModel(userViewModel: UserViewModel()))
                        ) {
                            HStack {
                                Text("Lists")
                                
                                Spacer()
                            }
                        }
                        
                        NavigationLink(
                            destination: ReviewsView(viewModel: ReviewsViewModel(userViewModel: UserViewModel()))
                        ) {
                            HStack {
                                Text("Reviews")
                                
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: AccountView(viewModel: AccountViewModel(userViewModel: userViewModel))
                    ) {
                        Text("Sign in to see your profile")
                            .padding(.horizontal, signInButtonPaddingHorizontal)
                            .padding(.vertical, signInButtonPaddingVertical)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
