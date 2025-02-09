import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    private let auth = Auth.auth()
    private let datastore = Firestore.firestore()
    
    private var lastFriendDocument: DocumentSnapshot?
    private var lastUserDocument: DocumentSnapshot?
    
    private var isSignedIn: Bool {
        auth.currentUser != nil
    }
    private var userDocument: DocumentReference {
        return datastore.collection("users").document(auth.currentUser!.uid)
    }
    
    // MARK: Authentication
    
    func sendPasswordReset(email: String) throws {
        guard !email.isEmpty else { throw AuthenticationError.emptyEmail }
        
        auth.sendPasswordReset(withEmail: email)
    }
    
    func signIn(email: String, password: String) async throws {
        guard !isSignedIn else { throw AuthenticationError.alreadySignedIn }
        guard !email.isEmpty else { throw AuthenticationError.emptyEmail }
        guard !password.isEmpty else { throw AuthenticationError.emptyPassword }
        
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        guard isSignedIn else { throw AuthenticationError.notSignedIn }
        
        try auth.signOut()
    }
    
    func signUp(username: String, email: String, password: String) async throws {
        guard !isSignedIn else { throw AuthenticationError.alreadySignedIn }
        guard !email.isEmpty else { throw AuthenticationError.emptyEmail }
        guard !password.isEmpty else { throw AuthenticationError.emptyPassword }
        guard !username.isEmpty else { throw AuthenticationError.emptyUsername }
        
        try await auth.createUser(withEmail: email, password: password)
        try await createUser(username: username)
    }
    
    // MARK: Datastore - Activities
    
    func retrieveActivities() async throws -> [Activity] {
        return []
    }
    
    // MARK: Datastore - Crates
    
    func createCrate(name: String, cover: URL? = nil, albums: [String]) throws {
        let crate = Crate(name: name, user_id: auth.currentUser!.uid, cover: cover, albums: albums)
        try userDocument.collection("crates").document(crate.id).setData(from: crate)
    }
    
    func deleteCrate(crate_id: String) {
        userDocument.collection("crates").document(crate_id).delete()
    }
    
    func retrieveCrates() async throws -> [Crate] {
        let crateDocuments = try await userDocument.collection("crates").getDocuments()
        if crateDocuments.isEmpty { return [] }
        
        return try crateDocuments.documents.compactMap { document in
            try document.data(as: Crate.self)
        }
    }
    
    func addToCrate(album: Album, crate: Crate) async throws {
        try await userDocument.collection("crates").document(crate.id).updateData(["album_ids": FieldValue.arrayUnion([album.id])])
    }
    
    func removeFromCrate(album: Album, crate: Crate) async throws {
        try await userDocument.collection("crates").document(crate.id).updateData(["album_ids": FieldValue.arrayRemove([album.id])])
    }
    
    // MARK: Datastore - Favorites - Albums
    
    func retrieveFavoriteAlbums() async throws -> [String] {
        return try await userDocument.getDocument().get("favorite_albums") as? [String] ?? []
    }
    
    func favoriteAlbum(album: Album) async throws {
        if try await isAlbumFavorited(album: album) {
            try await userDocument.updateData(["favorite_albums": FieldValue.arrayRemove([album.id])])
        } else {
            try await userDocument.updateData(["favorite_albums": FieldValue.arrayUnion([album.id])])
        }
    }
    
    func isAlbumFavorited(album: Album) async throws -> Bool {
        return try await retrieveFavoriteAlbums().contains(album.id)
    }
    
    // MARK: Datastore - Favorites - Tracks
    
    func retrieveAlbumFavorites(album_id: String) async throws -> [String] {
        let favorites = try await userDocument.getDocument().get("favorite_tracks") as? [String: [String]] ?? [:]
        return favorites[album_id] ?? []
    }
    
    func favoriteTrack(track: Track) async throws {
        if try await isTrackFavorited(track: track) {
            try await userDocument.updateData(["favorite_tracks.\(track.album_id)": FieldValue.arrayRemove([track.id])])
            
            let favorites = try await retrieveAlbumFavorites(album_id: track.album_id)
            if favorites.isEmpty {
                try await userDocument.updateData(["favorite_tracks.\(track.album_id)": FieldValue.delete()])
            }
        } else {
            try await userDocument.updateData(["favorite_tracks.\(track.album_id)": FieldValue.arrayUnion([track.id])])
        }
    }
    
    func isTrackFavorited(track: Track) async throws -> Bool {
        return try await retrieveAlbumFavorites(album_id: track.album_id).contains(track.id)
    }
    
    // MARK: Datastore - Friends
    
    func sendFriendRequest(user_id: String) async throws {
        try await userDocument.updateData(["friend_requests": FieldValue.arrayUnion([user_id])])
    }
    
    func acceptFriendRequest(user_id: String) async throws {
        try await userDocument.updateData(["friend_requests": FieldValue.arrayRemove([user_id])])
        try await userDocument.updateData(["friend": FieldValue.arrayUnion([user_id])])
    }
    
    func retrieveFriends(page: Int, batchSize: Int) async throws -> [User] {
        let friends = try await userDocument.getDocument().get("friends") as? [String] ?? []
        if friends.isEmpty { return [] }
        
        let start = (page - 1) * batchSize
        let end = min(start + batchSize, friends.count)
        
        let friendsChunk = Array(friends[start..<end])
        let friendsQuery = datastore.collection("users").whereField(FieldPath.documentID(), in: friendsChunk)
        return try await friendsQuery.getDocuments().documents.compactMap { document in
            try document.data(as: User.self)
        }
    }
    
    func removeFriend(user_id: String) async throws {
        try await userDocument.updateData(["friends": FieldValue.arrayRemove([user_id])])
    }
    
    // MARK: Datastore - Ratings
    
    func retrieveRating(album_id: String) async throws -> Double {
        let ratings = try await userDocument.getDocument().get("ratings") as? [String: Double] ?? [:]
        return ratings[album_id] ?? 0
    }
    
    func updateRating(id: String, rating: Double) async throws {
        if rating.isEqual(to: try await retrieveRating(album_id: id)) {
            try await userDocument.updateData(["ratings.\(id)": FieldValue.delete()])
        } else {
            try await userDocument.updateData(["ratings.\(id)": rating])
        }
    }
    
    // MARK: Datastore - Reviews
    
    func createReview(review: Review) throws {
        try userDocument.collection("reviews").document(review.id).setData(from: review)
    }
    
    func retrieveReviews() async throws -> [Review] {
        let reviewDocuments = try await userDocument.collection("reviews").getDocuments()
        if reviewDocuments.isEmpty { return [] }
        
        return try reviewDocuments.documents.compactMap { document in
            try document.data(as: Review.self)
        }
    }
    
    // MARK: Datastore - User
    
    func createUser(username: String) async throws {
        try datastore.collection("users").document(auth.currentUser!.uid).setData(from: User(username: username, id: auth.currentUser!.uid))
    }
    
    func retrieveUser() async throws -> User {
        return try await userDocument.getDocument().data(as: User.self)
    }
    
    func searchUsers(query: String, page: Int, batchSize: Int) async throws -> [User] {
        if page == 1 {
            lastUserDocument = nil
        }
        
        var usersQuery: Query = datastore.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThan: query + "\u{f8ff}")
            .limit(to: batchSize)
        
        if page > 1, let lastUserDocument = lastUserDocument {
            usersQuery = usersQuery.start(afterDocument: lastUserDocument)
        }
        
        let userDocuments = try await usersQuery.getDocuments().documents
        
        let users = userDocuments.compactMap { document in
            try? document.data(as: User.self)
        }
        
        lastUserDocument = userDocuments.last
        
        return users
    }
    
    // MARK: Errors
    
    enum AuthenticationError: Error {
        case alreadySignedIn, emptyEmail, emptyPassword, emptyUsername, notSignedIn
    }
}
