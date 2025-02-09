import Foundation
import Observation
import FirebaseAuth

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
            errorMessage = mapFirebaseError(error as NSError)
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
            errorMessage = mapFirebaseError(error as NSError)
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
            errorMessage = mapFirebaseError(error as NSError)
        }
        isLoading = false
    }
    
    private func mapFirebaseError(_ error: NSError) -> String {
        if let authError = AuthErrorCode(rawValue: error.code) {
            switch authError {
            case .wrongPassword:
                return "The password is incorrect. Please try again."
            case .invalidEmail:
                return "The email address is invalid. Please check and try again."
            case .userNotFound:
                return "No user found with this email. Please sign up first."
            case .networkError:
                return "Network error. Please check your internet connection."
            default:
                return "An unexpected error occurred: \(error.localizedDescription)"
            }
        }
        return "An unknown error occurred."
    }
}

enum AccountTab {
    case emailSignIn, emailSignUp, forgotPassword
}
