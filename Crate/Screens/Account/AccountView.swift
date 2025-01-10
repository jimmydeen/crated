import SwiftUI

struct AccountView: View {
    @State private var tab: AccountTab = .home
    @State private var homeMarqueeHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    
    @State var viewModel: AccountViewModel
    
    private let homeButtonWidth: CGFloat = 240
    private let homeButtonCornerRadius: CGFloat = 12
    private let homeButtonPaddingHorizontal: CGFloat = 16
    private let homeButtonPaddingVertical: CGFloat = 8
    private let homeMarqueeCornerRadius: CGFloat = 12
    private let homeMarqueeHeightNormal: CGFloat = UIScreen.main.bounds.height * 0.5
    private let homeMarqueeHeightSignUp: CGFloat = UIScreen.main.bounds.height * 0.3
    private let homeMarqueePaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.05
    private let homeMarqueeWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    private let homePaddingBottom: CGFloat = UIScreen.main.bounds.height * 0.05
    
    var body: some View {
        ZStack {
            VStack {
                Image("accountbg")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: homeMarqueeWidth,
                        height: tab == .emailSignUp ? homeMarqueeHeightSignUp : homeMarqueeHeightNormal
                    )
                    .clipped()
                    .cornerRadius(homeMarqueeCornerRadius)
                    .padding(.bottom, homeMarqueePaddingBottom)
                
                if tab == .home {
                    VStack {
                        homeButton(text: "Google Sign In", tab: .googleSignIn)
                            .padding(.bottom)
                        homeButton(text: "Sign In", tab: .emailSignIn)
                        homeButton(text: "Create account", tab: .emailSignUp)
                    }
                }
                if tab == .emailSignIn {
                    SignInFormView(viewModel: $viewModel)
                }
                if tab == .emailSignUp {
                    SignUpFormView(viewModel: $viewModel)
                }
                
                Spacer()
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
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    
    @Binding var viewModel: AccountViewModel
    
    private let fieldCornerRadius: CGFloat = 6
    private let fieldGroupSpacing: CGFloat = 16
    private let fieldPaddingHorizontal: CGFloat = 8
    private let fieldPaddingVertical: CGFloat = 4
    private let fieldWidth: CGFloat = 300
    private let formPaddingTop: CGFloat = 24
    private let signInButtonWidth: CGFloat = 120
    
    var body: some View {
        VStack(spacing: fieldGroupSpacing) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Email")
                    .font(.title2)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Password")
                    .font(.title2)
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        Task {
                            await viewModel.signIn(
                                email: email,
                                password: password
                            )
                            if viewModel.successMessage != nil {
                                showAlert = true
                            }
                        }
                    }
                ) {
                    Text("Sign in")
                        .font(.title2)
                        .frame(width: signInButtonWidth)
                        .padding(.horizontal, fieldPaddingHorizontal)
                        .padding(.vertical, fieldPaddingVertical)
                        .background(Color.lightGray)
                        .cornerRadius(fieldCornerRadius)
                }
                .disabled(viewModel.isLoading)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text(viewModel.successMessage ?? ""),
                        dismissButton: .default(Text("OK")) {
                            dismiss()
                        }
                    )
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
        .frame(width: fieldWidth)
    }
}

struct SignUpFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false

    @Binding var viewModel: AccountViewModel

    private let fieldCornerRadius: CGFloat = 6
    private let fieldGroupSpacing: CGFloat = 16
    private let fieldPaddingHorizontal: CGFloat = 8
    private let fieldPaddingVertical: CGFloat = 4
    private let fieldWidth: CGFloat = 300
    private let formPaddingTop: CGFloat = 24
    private let signUpButtonWidth: CGFloat = 120

    var body: some View {
        VStack(spacing: fieldGroupSpacing) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Username")
                    .font(.title2)
                TextField("Enter your username", text: $username)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("Email")
                    .font(.title2)
                TextField("Enter your email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("Password")
                    .font(.title2)
                SecureField("Enter your password", text: $password)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("Confirm Password")
                    .font(.title2)
                SecureField("Re-enter your password", text: $confirmPassword)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Spacer()
                
                Button(
                    action: {
                        guard password == confirmPassword else {
                            viewModel.errorMessage = "Passwords do not match."
                            return
                        }
                        Task {
                            await viewModel.signUp(
                                username: username,
                                email: email,
                                password: password
                            )
                            if viewModel.successMessage != nil {
                                showAlert = true
                            }
                        }
                    }
                ) {
                    Text("Sign Up")
                        .font(.title2)
                        .frame(width: signUpButtonWidth)
                        .padding(.horizontal, fieldPaddingHorizontal)
                        .padding(.vertical, fieldPaddingVertical)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(fieldCornerRadius)
                }
                .disabled(viewModel.isLoading)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text(viewModel.successMessage ?? ""),
                        dismissButton: .default(Text("OK")) {
                            dismiss()
                        }
                    )
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
        .frame(width: fieldWidth)
    }
}

struct AccountViewPreview: PreviewProvider {
    static var previews: some View {
        AccountView(viewModel: AccountViewModel(userViewModel: UserViewModel()))
    }
}
