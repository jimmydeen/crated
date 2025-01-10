import Foundation
import Observation
import FirebaseFirestore

enum SignInError: Error {
    case emptyPassword, emptyEmail, emptyUsername
}

@Observable class UserViewModel {
    var currentUser: UserModel? = nil
    var isAuthenticated: Bool = false
    var errorMessage: String? = nil
    
    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty else {
            throw SignInError.emptyEmail
        }
        guard !password.isEmpty else {
            throw SignInError.emptyPassword
        }
        
        do {
            let user = try await IdentityService.shared.signInUser(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
            throw error
        }
    }
    
    func signUp(username: String, email: String, password: String) async throws {
        guard !username.isEmpty else {
            throw SignInError.emptyUsername
        }
        guard !email.isEmpty else {
            throw SignInError.emptyEmail
        }
        guard !password.isEmpty else {
            throw SignInError.emptyPassword
        }
        
        do {
            let user = try await IdentityService.shared.signUpUser(username: username, email: email, password: password)
            
            let db = Firestore.firestore()
            let newUser = UserModel(
                name: username,
                cover: nil,
                date_joined: Date(),
                album_ratings: [:],
                favorite_albums: [],
                favorite_tracks: [:],
                friends: [],
                lists: [],
                location_longitude: nil,
                location_latitude: nil,
                id: user.id
            )
            
            let userDict = try newUser.toDictionary()
            try await db.collection("users").document(user.id).setData(userDict)
            
            currentUser = newUser
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
            throw error
        }
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
}
