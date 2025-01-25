import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = AccountViewModel()
    
    private let textBoxBorderWidth: CGFloat = 1
    private let textBoxCornerRadius: CGFloat = 8
    private let textBoxInternalPadding: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.tab {
                case .emailSignIn: signInForm
                case .emailSignUp: signUpForm
                case .forgotPassword: forgotPasswordForm
            }
        }
        .padding(.horizontal)
    }
    
    var signInForm: some View {
        VStack(alignment: .leading) {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
            
            SecureField("Password", text: $viewModel.password)
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
            
            Button("Sign In") {
                Task {
                    await viewModel.signIn()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
            .disabled(viewModel.isLoading)
            
            Divider()
            
            Button("Create Account") {
                viewModel.changeTab(.emailSignUp)
            }
            .disabled(viewModel.isLoading)
            
            Divider()
            
            Button("Forgot Password") {
                viewModel.changeTab(.forgotPassword)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
            }
            if let success = viewModel.successMessage {
                Text(success)
            }
            
            Spacer()
        }
    }
    
    var signUpForm: some View {
        VStack(alignment: .leading) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Button("Go back") {
                viewModel.changeTab(.emailSignIn)
            }
            
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
                
            SecureField("Password", text: $viewModel.password)
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
                
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
            
            Button("Sign Up") {
                Task {
                    await viewModel.signUp()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
            .disabled(viewModel.isLoading)
            
            if let error = viewModel.errorMessage {
                Text(error)
            }
            if let success = viewModel.successMessage {
                Text(success)
            }
            
            Spacer()
        }
    }
    
    var forgotPasswordForm: some View {
        VStack(alignment: .leading) {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Button("Go back") {
                viewModel.changeTab(.emailSignIn)
            }
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(textBoxInternalPadding)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: textBoxCornerRadius)
                        .stroke(.gray, lineWidth: textBoxBorderWidth)
                )
            
            Button("Send Email") {
                viewModel.sendPasswordReset()
            }
            
            Button("Continue to Sign In") {
                viewModel.changeTab(.emailSignIn)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
            }
            if let success = viewModel.successMessage {
                Text(success)
            }
            
            Spacer()
        }
    }
}

struct AccountViewPreview: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environment(DisplayViewModel())
    }
}
