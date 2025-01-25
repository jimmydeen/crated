import Foundation
import Observation

@Observable class AccountViewModel: UserViewModel {
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var successMessage: String? = nil
    var tab: AccountTab = .emailSignIn
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    // MARK: Authentication
    
    func changeTab(_ tab: AccountTab) {
        errorMessage = nil
        isLoading = false
        successMessage = nil
        self.tab = tab
        
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
    func sendPasswordReset() {
        isLoading = true
        errorMessage = nil
        do {
            try user.sendPasswordReset(email: email)
            successMessage = "Email sent!"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func signIn() async {
        isLoading = true
        errorMessage = nil
        do {
            try await user.signIn(email: email, password: password)
            successMessage = "Successfully signed in!"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func signUp() async {
        isLoading = true
        errorMessage = nil
        do {
            try await user.signUp(username: username, email: email, password: password)
            successMessage = "Successfully created account!"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: Tabs
    
    public enum AccountTab {
        case emailSignIn, emailSignUp, forgotPassword
    }
}
