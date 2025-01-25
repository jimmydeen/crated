import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable class UserService {
    static let shared = UserService()
    
    private init() {}
    
    private let auth = Auth.auth()
    private let datastore = Firestore.firestore()
    
    private var activities: [ActivityModel]?
    private var ratings: [String: Double]?
    private var reviews: [String: ReviewModel]?
    private var user: UserModel?
    
    // MARK: Authentication
    
    var isAuthenticated: Bool {
        return user != nil
    }
    
    func sendPasswordReset(email: String) throws {
        auth.sendPasswordReset(withEmail: email)
    }
    public func signIn(email: String, password: String) async throws {
        guard !email.isEmpty else { throw AuthenticationError.emptyEmailAddress }
        guard !password.isEmpty else { throw AuthenticationError.emptyPassword }
        
        let authResult = try await auth.signIn(withEmail: email, password: password)
        
        let userID = authResult.user.uid
        let userDoc = datastore.collection("users").document(userID)
        let snapshot = try await userDoc.getDocument()
        
        guard let userData = snapshot.data() else {
            throw AuthenticationError.failedToRetrieveUserData
        }
        print(userData)
        
        let dictDecoder = Firestore.Decoder()
        self.user = try dictDecoder.decode(UserModel.self, from: userData)
    }
    public func signOut() throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        try auth.signOut()
        user = nil
    }
    public func signUp(username: String, email: String, password: String) async throws {
        guard !email.isEmpty else { throw AuthenticationError.emptyEmailAddress }
        guard !password.isEmpty else { throw AuthenticationError.emptyPassword }
        
        try await auth.createUser(withEmail: email, password: password)
        
        let userID = auth.currentUser!.uid
        let user = UserModel(name: username, id: userID)
        let dictEncoder = Firestore.Encoder()
        let userData = try dictEncoder.encode(user)
        
        let userDoc = datastore.collection("users").document(userID)
        try await userDoc.setData(userData)
        
        self.user = user
    }
    
    // MARK: Datastore - Activities
    
    public func createActivity(activity: ActivityModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
    }
    public func retrieveActivities() async throws -> [ActivityModel] {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        return []
    }
    
    // MARK: Datastore - Favorites - Albums
    
    public func retrieveFavoriteAlbums() async throws -> [String] {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let userDoc = datastore.collection("users").document(user!.id)
        let snapshot = try await userDoc.getDocument()
        let favorites = snapshot.data()?["favorite_albums"] as? [String] ?? []
        
        return favorites
    }
    public func favoriteAlbum(album: AlbumModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_albums.isEmpty { user!.favorite_albums = try await retrieveFavoriteAlbums() }
        
        let userDoc = datastore.collection("users").document(user!.id)
        try await userDoc.updateData(["favorite_albums": FieldValue.arrayUnion([album.id])])
        
        user!.favorite_albums.append(album.id)
    }
    public func unfavoriteAlbum(album: AlbumModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_albums.isEmpty { user!.favorite_albums = try await retrieveFavoriteAlbums() }
        
        let userDoc = datastore.collection("users").document(user!.id)
        try await userDoc.updateData(["favorite_albums": FieldValue.arrayRemove([album.id])])
        
        user!.favorite_albums.removeAll(where: { $0 == album.id })
    }
    public func isAlbumFavorited(album: AlbumModel) async throws -> Bool {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_albums.isEmpty { user!.favorite_albums = try await retrieveFavoriteAlbums() }
        
        return user!.favorite_albums.contains(album.id)
    }
    
    // MARK: Datastore - Favorites - Tracks
    
    public func retrieveFavoriteTracks() async throws {
        let userDoc = datastore.collection("users").document(user!.id)
        let snapshot = try await userDoc.getDocument()
        let favorites = snapshot.data()?["favorite_tracks"] as? [String : [String]] ?? [:]
        
        user!.favorite_tracks = favorites
    }
    public func retrieveAlbumFavorites(album: AlbumModel) async throws -> [String] {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_tracks.isEmpty { try await retrieveFavoriteTracks() }
        
        return user!.favorite_tracks[album.id] ?? []
    }
    public func favoriteTrack(track: TrackModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_tracks.isEmpty { try await retrieveFavoriteTracks() }
        
        let userDoc = datastore.collection("users").document(user!.id)
        try await userDoc.updateData(["favorite_tracks.\(track.album_id)": FieldValue.arrayUnion([track.id])])
        
        if !user!.favorite_tracks.keys.contains(track.album_id) {
            user!.favorite_tracks[track.album_id] = [track.id]
        } else {
            user!.favorite_tracks[track.album_id]?.append(track.id)
        }
    }
    public func unfavoriteTrack(track: TrackModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_tracks.isEmpty { try await retrieveFavoriteTracks() }
        
        let userDoc = datastore.collection("users").document(user!.id)
        try await userDoc.updateData(["favorite_tracks.\(track.album_id)": FieldValue.arrayRemove([track.id])])
        
        user!.favorite_tracks[track.album_id]?.removeAll(where: { $0 == track.id })
        if user!.favorite_tracks[track.album_id]?.isEmpty ?? false {
            user!.favorite_tracks.removeValue(forKey: track.album_id)
        }
    }
    public func isTrackFavorited(track: TrackModel) async throws -> Bool {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        if user!.favorite_tracks.isEmpty { try await retrieveFavoriteTracks() }
        
        return user!.favorite_tracks[track.album_id]?.contains(track.id) ?? false
    }
    
    // MARK: Datastore - Friends
    
    public func addFriend(user_id: String) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let userDoc = datastore.collection("users").document(user!.id)
        try await userDoc.updateData(["friends": FieldValue.arrayUnion([user_id])])
        user!.friends.append(user_id)
    }
    public func removeFriend(user_id: String) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let userDoc = datastore.collection("users").document(user!.id)
        try await userDoc.updateData(["friends": FieldValue.arrayRemove([user_id])])
        user!.friends.removeAll(where: { $0 == user_id })
    }
    
    // MARK: Datastore - Lists
    
    public func createList(list: ListModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let listsCollection = datastore.collection("users").document(user!.id).collection("lists")
        try await listsCollection.document(list.id).setData([
            "name": list.name,
            "albums": list.albums
        ])
    }
    public func retrieveLists() async throws -> [ListModel] {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let listsCollection = datastore.collection("users").document(user!.id).collection("lists")
        let snapshot = try await listsCollection.getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let name = doc["name"] as? String ?? ""
            let albums = doc["albums"] as? [String] ?? []
            return ListModel(name: name, user_id: user!.id, cover_hq: nil, cover_lq: nil, albums: albums, id: doc.documentID)
        }
    }
    public func addToList(album: AlbumModel, list: ListModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let listsCollection = datastore.collection("users").document(user!.id).collection("lists")
        let listDoc = listsCollection.document(list.id)
        try await listDoc.updateData(["album_ids": FieldValue.arrayUnion([album.id])])
    }
    public func removeFromList(album: AlbumModel, list: ListModel) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let listsCollection = datastore.collection("users").document(user!.id).collection("lists")
        let listDoc = listsCollection.document(list.id)
        try await listDoc.updateData(["album_ids": FieldValue.arrayRemove([album.id])])
    }
    
    // MARK: Datastore - Ratings
    
    public func retrieveRating(album: AlbumModel) async throws -> Double {
        if ratings == nil { try await retrieveRatings() }
        
        return ratings?[album.id] ?? 0
    }
    public func retrieveRatings() async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let ratingsCollection = datastore.collection("users").document(user!.id).collection("ratings")
        let snapshot = try await ratingsCollection.getDocuments()

        ratings = snapshot.documents.reduce(into: [String: Double]()) { result, doc in
            if let rating = doc["rating"] as? Double {
                result[doc.documentID] = rating
            }
        }
    }
    public func updateRating(id: String, rating: Double) async throws {
        if ratings == nil { try await retrieveRatings() }
        
        let userDoc = datastore.collection("users").document(user!.id)
        if rating == 0 {
            try await userDoc.updateData(["ratings.\(id)": FieldValue.delete()])
            ratings!.removeValue(forKey: id)
        } else {
            try await userDoc.updateData(["ratings.\(id)": rating])
            ratings![id] = rating
        }
    }
    
    // MARK: Datastore - Reviews
    
    public func retrieveReviews() async throws -> [ReviewModel] {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let reviewsCollection = datastore.collection("users").document(user!.id).collection("reviews")
        let snapshot = try await reviewsCollection.getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let album_id = doc["album"] as! String
            let title = doc["title"] as? String
            let description = doc["description"] as? String
            let rating = doc["rating"] as? Double
            return ReviewModel(
                album_id: album_id,
                type: ReviewModel.ReviewType.rating,
                title: title ?? "",
                rating: rating ?? nil,
                description: description ?? nil
            )
        }
    }
    
    // MARK: Datastore - User
    
    public func createUser(username: String) async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        let user = UserModel(name: username, id: auth.currentUser!.uid)
        
        let dictEncoder = Firestore.Encoder()
        let userData = try dictEncoder.encode(user)
        let userEntry = datastore.collection("users").document()
        
        try await userEntry.setData(userData)
        self.user = user
    }
    public func retrieveUser() async throws {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        let userDoc = datastore.collection("users").document(auth.currentUser!.uid)
        let snapshot = try await userDoc.getDocument()
        
        guard let data = snapshot.data() else {
            throw AuthenticationError.notAuthenticated
        }
        
        let dictDecoder = Firestore.Decoder()
        let user = try dictDecoder.decode(UserModel.self, from: data)
        self.user = user
    }
    public func retrieveUsers(query: String, page: Int, batchSize: Int) async throws -> [UserModel] {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        return []
    }
    public func retrieveName() throws -> String {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        return user!.name
    }
    public func retrieveProfileCoverLQ() throws -> URL? {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        return user!.cover_lq
    }
    public func retrieveProfileCoverHQ() throws -> URL? {
        guard isAuthenticated else { throw AuthenticationError.notAuthenticated }
        
        return user!.cover_hq
    }
    
    // MARK: Errors
    
    private enum AuthenticationError: Error {
        case emptyEmailAddress, emptyPassword, emptyUsername, failedToRetrieveUserData, notAuthenticated
    }
}
