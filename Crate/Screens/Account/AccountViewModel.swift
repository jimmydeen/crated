import Foundation
import Observation

@Observable class AccountViewModel: UserViewModel {
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var successMessage: String? = nil
    var tab: AccountTab = .home

    // MARK: Authentication
    
    public func signIn(email: String, password: String) async {
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
    public func signUp(username: String, email: String, password: String) async {
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
        case home, emailSignIn, emailSignUp
    }
}
