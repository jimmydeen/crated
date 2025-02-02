import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = AccountViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.tab {
                case .emailSignIn: signInForm
                case .emailSignUp: signUpForm
                case .forgotPassword: forgotPasswordForm
            }
            
            alerts
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    var signInForm: some View {
        Group {
            Title(text: "Sign In")
            
            RoundedTextField(text: $viewModel.email, placeholder: "Email")
            
            RoundedSecureField(text: $viewModel.password, placeholder: "Password")
            
            RoundedButton(text: "Sign In") {
                Task {
                    await viewModel.signIn()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
            
            RoundedButton(text: "Create Account") {
                viewModel.changeTab(tab: .emailSignUp)
            }
            .disabled(viewModel.isLoading)
            
            RoundedButton(text: "Forgot Password") {
                viewModel.changeTab(tab: .forgotPassword)
            }
        }
    }
    
    var signUpForm: some View {
        Group {
            Title(text: "Create Account")
            
            RoundedButton(text: "Go back") {
                viewModel.changeTab(tab: .emailSignIn)
            }
            
            RoundedTextField(text: $viewModel.username, placeholder: "Username")
            
            RoundedTextField(text: $viewModel.email, placeholder: "Email")
            
            RoundedSecureField(text: $viewModel.password, placeholder: "Password")
            
            RoundedSecureField(text: $viewModel.confirmPassword, placeholder: "Confirm Password")
            
            RoundedButton(text: "Sign Up") {
                Task {
                    await viewModel.signUp()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    var forgotPasswordForm: some View {
        Group {
            Title(text: "Forgot Password")
            
            RoundedButton(text: "Go back") {
                viewModel.changeTab(tab: .emailSignIn)
            }
            
            RoundedTextField(text: $viewModel.email, placeholder: "Email")
            
            RoundedButton(text: "Send email") {
                viewModel.sendPasswordReset()
            }
            
            RoundedButton(text: "Continue to sign in") {
                viewModel.changeTab(tab: .emailSignIn)
            }
        }
    }
    
    private var alerts: some View {
        Group {
            if let error = viewModel.errorMessage {
                Text(error)
            }
            
            if let success = viewModel.successMessage {
                Text(success)
            }
        }
    }
}

struct AccountViewPreviews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environment(Authentication())
            .previewDisplayName("Account (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        AccountView()
            .environment(Authentication())
            .previewDisplayName("Account (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
