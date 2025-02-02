import Foundation
import Observation
import FirebaseAuth

@Observable class Authentication {
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
    init() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = (user != nil)
        }
    }
    
    deinit {
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
    }
}
