import Foundation
import FirebaseAuth
import FirebaseFirestore

class IdentityService {
    static let shared = IdentityService()
    
    private init() {}
    
    private let auth = Auth.auth()
    
    func signUp(username: String, email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    func signOut() throws {
        try auth.signOut()
    }
}
