import Foundation
import Observation

@Observable class AccountViewModel {
    private let user: UserService = .shared
    
    private(set) var errorMessage: String? = nil
    private(set) var isLoading: Bool = false
    private(set) var successMessage: String? = nil
    private(set) var tab: AccountTab = .emailSignIn
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    // MARK: Authentication
    
    func changeTab(tab: AccountTab) {
        errorMessage = nil
        isLoading = false
        successMessage = nil
        
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
        
        self.tab = tab
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
}

enum AccountTab {
    case emailSignIn, emailSignUp, forgotPassword
}
