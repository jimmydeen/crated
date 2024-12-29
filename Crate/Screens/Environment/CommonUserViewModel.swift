import Observation
import CoreData

@Observable class CommonUserViewModel {
    private var context: NSManagedObjectContext
    
    var activities: [ActivityModel] = []
    var albumRatings: [String: Double] = [:]
    var likedTracksByAlbum: [String: [String: Bool]] = [:]
    var isSignedIn: Bool = false

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private var cachedUser: UserModel?

    public var user: UserModel? {
        if let cachedUser = cachedUser {
            return cachedUser
        }
        let userFetchRequest = UserModel.fetchRequest()
        if let user = try? context.fetch(userFetchRequest).first {
            self.cachedUser = user
            return user
        } else {
            let profile = ProfileModel(context: context)
            let user = UserModel(context: context)
            
            profile.id = UUID()
            profile.profile_user = user
            profile.favorites = []
            user.user_profile = profile
            user.date_joined = Date.now
            user.name = "andredavisws"
            user.id = UUID()
            
            do {
                try self.context.save()
            } catch {
                print(error)
                return nil
            }
            self.cachedUser = user
            return user
        }
    }
    
    public func addUserActivity(_ activity: ActivityModel) {
        activities.append(activity)
    }
    public func addAlbumToFavorites(_ album: AlbumModel) {
        guard let user = self.user else { return }
        var favorites = Set(user.user_profile.favorites.compactMap { $0 as? String })
        favorites.insert(album.id)
        user.user_profile.favorites = NSSet(array: favorites.map { $0 })
            
        let activity = ActivityModel(
            username: user.name,
            date: Date.now,
            type: ActivityType.FavoriteAdd,
            album: album
        )
        activities.append(activity)
        
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }
    public func isAlbumFavorite(album: AlbumModel) -> Bool {
        if let user = self.user {
            let favorites = user.user_profile.favorites
            return favorites.contains(album.id)
        } else {
            return false
        }
    }
    public func likeTrackInAlbum(track: TrackModel) {
        self.likedTracksByAlbum[track.album_id, default: [:]][track.id] = true
    }
    public func removeAlbumFromFavorites(album: AlbumModel) {
        if let user = self.user {
            let set = NSMutableSet(set: user.user_profile.favorites)
            set.remove(album.id)
            user.user_profile.favorites = NSSet(set: set)
            
            let activity = ActivityModel(
                id: UUID(),
                username: user.name,
                date: Date.now,
                type: ActivityType.FavoriteRemove,
                album: album
            )
            activities.insert(activity, at: 0)
            
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
    }
    public func changeAlbumRating(for album: AlbumModel, to rating: Double) {
        self.albumRatings[album.id] = rating
    }
    public func unlikeTrackInAlbum(track: TrackModel) {
        if self.likedTracksByAlbum[track.album_id] != nil {
            self.likedTracksByAlbum[track.album_id]![track.id] = nil
        }
    }
}
