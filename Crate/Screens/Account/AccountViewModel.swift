import Foundation
import Observation
import FirebaseFirestore

@Observable class AccountViewModel {
    var tab: AccountTab = .home
    var errorMessage: String? = nil
    var successMessage: String? = nil
    var isLoading: Bool = false
    
    let userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await userViewModel.signIn(email: email, password: password)
            successMessage = "Successfully signed in!"
        } catch {
            errorMessage = userViewModel.errorMessage
        }
        isLoading = false
    }
    
    func signUp(username: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await userViewModel.signUp(username: username, email: email, password: password)
            successMessage = "Successfully created account!"
        } catch {
            errorMessage = userViewModel.errorMessage
        }
        isLoading = false
    }
    
    enum AccountTab: String {
        case home, emailSignIn, emailSignUp, googleSignIn
    }
}
