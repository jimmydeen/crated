import Foundation
import FirebaseAuth
import FirebaseFirestore

class IdentityService {
    static let shared = IdentityService()
    var currentUser: UserModel?

    private let db = Firestore.firestore()

    func signInUser(email: String, password: String) async throws -> UserModel {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let uid = authResult.user.uid

        let snapshot = try await db.collection("users").document(uid).getDocument()
        guard let data = snapshot.data() else {
            throw NSError(domain: "IdentityService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found."])
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let user = try JSONDecoder().decode(UserModel.self, from: jsonData)
            self.currentUser = user
            return user
        } catch {
            throw NSError(domain: "IdentityService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error decoding user data: \(error.localizedDescription)"])
        }
    }

    func signOutUser() throws {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
        } catch let error {
            throw NSError(domain: "IdentityService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error signing out: \(error.localizedDescription)"])
        }
    }
    
    func signUpUser(username: String, email: String, password: String) async throws -> UserModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = authResult.user.uid

        let newUser = UserModel(
            name: email,
            cover: nil,
            date_joined: Date(),
            album_ratings: [:],
            favorite_albums: [],
            favorite_tracks: [:],
            friends: [],
            lists: [],
            location_longitude: nil,
            location_latitude: nil,
            id: uid
        )

        do {
            let userDict = try newUser.toDictionary()
            try await db.collection("users").document(uid).setData(userDict)
            self.currentUser = newUser
            return newUser
        } catch {
            throw NSError(domain: "IdentityService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error saving user data: \(error.localizedDescription)"])
        }
    }
}
