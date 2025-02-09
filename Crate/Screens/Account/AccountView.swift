import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = AccountViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.tab {
                case .emailSignIn: emailSignInForm
                case .emailSignUp: emailSignUpForm
                case .forgotPassword: forgotPasswordForm
            }
            
            alerts
            
            Spacer()
        }
        .padding(.standard)
    }
    
    var emailSignInForm: some View {
        Group {
            Title(text: "Sign In")
            
            RoundedTextField(text: $viewModel.email, placeholder: "Email")
            
            RoundedTogglableSecureField(text: $viewModel.password, placeholder: "Password")
            
            HStack {
                RoundedSecondaryButton(text: "Forgot Password") {
                    viewModel.changeTab(tab: .forgotPassword)
                }
                
                RoundedButton(text: "Sign In") {
                    Task {
                        await viewModel.signIn()
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                }
            }
            .padding(.bottom, .standard)
            
            RoundedButton(text: "Create Account") {
                viewModel.changeTab(tab: .emailSignUp)
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    var emailSignUpForm: some View {
        Group {
            Title(text: "Create Account")
            
            RoundedTextField(text: $viewModel.email, placeholder: "Email")
            
            RoundedTextField(text: $viewModel.username, placeholder: "Username")
            
            RoundedTogglableSecureField(text: $viewModel.password, placeholder: "Password")
            
            RoundedTogglableSecureField(text: $viewModel.confirmPassword, placeholder: "Confirm Password")
                .padding(.bottom, .standard)
            
            HStack {
                RoundedButton(text: "Back") {
                    viewModel.changeTab(tab: .emailSignIn)
                }
                
                RoundedButton(text: "Continue") {
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
    }
    
    var forgotPasswordForm: some View {
        Group {
            Title(text: "Account Recovery")
            
            RoundedTextField(text: $viewModel.email, placeholder: "Email")
                .padding(.bottom, .standard)
            
            HStack {
                RoundedButton(text: "Back") {
                    viewModel.changeTab(tab: .emailSignIn)
                }
                
                RoundedButton(text: "Continue") {
                    viewModel.sendPasswordReset()
                }
            }
        }
    }
    
    private var alerts: some View {
        Group {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.primary)
            }
            
            if let success = viewModel.successMessage {
                Text(success)
                    .foregroundColor(.red)
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
