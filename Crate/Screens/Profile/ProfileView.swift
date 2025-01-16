import SwiftUI
import Kingfisher

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    
    private let cellSize: CGFloat = (UIScreen.main.bounds.width * 0.888) / 3
    private let detailsButtonsSpacing: CGFloat = 20
    private let detailsHeight: CGFloat = UIScreen.main.bounds.width * 0.216
    private let detailsPaddingLeading: CGFloat = 2
    private let detailsWidth: CGFloat = UIScreen.main.bounds.width * 0.5
    private let detailsUsernamePaddingBottom: CGFloat = 2
    private let fullDetailsPaddingHorizontal: CGFloat = 36
    private let gridSpacing: CGFloat = UIScreen.main.bounds.width * 0.028
    private let profilePicturePaddingTrailing: CGFloat = 10
    private let rowCellCount: Int = 3
    private let signInButtonPaddingHorizontal: CGFloat = 12
    private let signInButtonPaddingVertical: CGFloat = 6
    private let suburbOffsetX: CGFloat = -4
    private let suburbOffsetY: CGFloat = 1
    
    var body: some View {
        NavigationStack {
            if viewModel.isAuthenticated {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("@\(viewModel.fetchUsername())")
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
                            }
                            .frame(width: detailsWidth, height: detailsHeight)
                            
                            Spacer()
                            
                            KFImage(viewModel.fetchProfileURL())
                                .resizable()
                                .placeholder {
                                    PlaceholderView()
                                }
                                .frame(width: detailsHeight)
                        }
                        .frame(height: detailsHeight)
                        .padding(.horizontal, fullDetailsPaddingHorizontal)
                        
                        VStack {
                            Divider()
                            
                            NavigationLink(destination: FavoritesView()) {
                                HStack {
                                    Text("Favorites")
                                        .font(.title3)
                                    
                                    Spacer()
                                }
                            }
                            
                            Divider()
                            
                            NavigationLink(destination: ListsView()) {
                                HStack {
                                    Text("Lists")
                                        .font(.title3)
                                    
                                    Spacer()
                                }
                            }
                            
                            Divider()
                            
                            NavigationLink(destination: ReviewsView()) {
                                HStack {
                                    Text("Reviews")
                                        .font(.title3)
                                    
                                    Spacer()
                                }
                            }
                            
                            Divider()
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: AccountView(viewModel: AccountViewModel())
                    ) {
                        Text("Sign in to see your profile")
                            .foregroundColor(.black)
                            .padding(.horizontal, signInButtonPaddingHorizontal)
                            .padding(.vertical, signInButtonPaddingVertical)
                            .background(Color.lightGray)
                            .cornerRadius(12)
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
            .environment(UserViewModel())
    }
}
