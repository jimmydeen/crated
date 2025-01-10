import SwiftUI

struct AccountView: View {
    @State private var tab: AccountTab = .home
    @State private var viewModel: SignInViewModel = SignInViewModel()
    
    private let homeButtonWidth: CGFloat = 240
    private let homeButtonCornerRadius: CGFloat = 12
    private let homeButtonPaddingHorizontal: CGFloat = 16
    private let homeButtonPaddingVertical: CGFloat = 8
    private let homeMarqueeCornerRadius: CGFloat = 12
    private let homeMarqueeHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    private let homeMarqueeWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    private let homePaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.05
    
    var body: some View {
        ZStack {
            VStack {
                Image("accountbg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: homeMarqueeWidth, height: homeMarqueeHeight)
                    .clipped()
                    .cornerRadius(homeMarqueeCornerRadius)
                
                Spacer()
                
                if tab == .home {
                    VStack {
                        homeButton(text: "Google Sign In", tab: .googleSignIn)
                            .padding(.bottom)
                        homeButton(text: "Sign In", tab: .emailSignIn)
                        homeButton(text: "Create account", tab: .emailSignUp)
                    }
                    .transition(.move(edge: .leading))
                }
                if tab == .emailSignIn {
                    SignInFormView(viewModel: $viewModel)
                }
                if tab == .emailSignUp {
                    SignUpFormView(viewModel: $viewModel)
                }
            }
            .padding(.bottom, homePaddingBottom)
        }
    }
    
    private enum AccountTab: String {
        case home, emailSignIn, emailSignUp, googleSignIn
    }
    private func homeButton(text: String, tab: AccountTab) -> some View {
        Button(
            action: {
                self.tab = tab
            }
        ) {
            Text(text)
                .font(.title2)
                .frame(width: homeButtonWidth)
                .padding(.horizontal, homeButtonPaddingHorizontal)
                .padding(.vertical, homeButtonPaddingVertical)
                .background(Color.lightGray)
                .cornerRadius(homeButtonCornerRadius)
        }
    }
}

struct SignInFormView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var isSecure: Bool = true
    
    @Binding var viewModel: SignInViewModel
    
    private let fieldCornerRadius: CGFloat = 6
    private let fieldPaddingHorizontal: CGFloat = 8
    private let fieldPaddingVertical: CGFloat = 4
    private let fieldWidth: CGFloat = 300
    private let signInButtonWidth: CGFloat = 120
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Username")
                .font(.title)
            TextField("e.g. johndoe123", text: $username)
                .autocapitalization(.none)
                .padding(.horizontal, fieldPaddingHorizontal)
                .padding(.vertical, fieldPaddingVertical)
                .background(Color.lightGray)
                .cornerRadius(fieldCornerRadius)
                .padding(.bottom, 24)
            
            Text("Password")
                .font(.title)
            SecureField("e.g. password6969", text: $password)
                .autocapitalization(.none)
                .padding(.horizontal, fieldPaddingHorizontal)
                .padding(.vertical, fieldPaddingVertical)
                .background(Color.lightGray)
                .cornerRadius(fieldCornerRadius)
            
            HStack {
                Spacer()
                
                Button(
                    viewModel.signIn(
                ) {
                    Text("Sign in")
                        .font(.title2)
                        .frame(width: signInButtonWidth)
                        .padding(.horizontal, fieldPaddingHorizontal)
                        .padding(.vertical, fieldPaddingVertical)
                        .background(Color.lightGray)
                        .cornerRadius(fieldCornerRadius)
                }
            }
        }
        .frame(width: fieldWidth)
    }
}

struct SignUpFormView: View {
    @State var signInID: String = ""
    @State var password: String = ""
    
    @Binding var viewModel: SignInViewModel
    
    var body: some View {
        Text("Sign Up")
    }
}

struct AccountViewPreview: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
