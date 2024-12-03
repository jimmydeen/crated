import Observation
import CoreData

@Observable class CommonUserViewModel {
    private var context: NSManagedObjectContext
    
    var activities: [ActivityModel] = []
    var likedTracks: [String: [String: Bool]] = [:]
    var ratings: [String: Double] = [:]
    var isSignedIn: Bool = false

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    public var user: UserModel? {
        let userFetchRequest = UserModel.fetchRequest()
        
        if let user = try? context.fetch(userFetchRequest).first {
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
            return user
        }
    }
    
    public func addActivity(_ activity: ActivityModel) {
        activities.append(activity)
    }
    public func addFavorite(_ album: AlbumModel) {
        if let user = self.user {
            let set = NSMutableSet(set: user.user_profile.favorites)
            set.add(album.id)
            user.user_profile.favorites = NSSet(set: set)
            
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
    }
    public func addFriend(_ id: UUID) {
        if let user = self.user {
            let friendship = FriendshipModel(user_id_A: user.id, user_id_B: id)
            
        }
    }
    public func isAlbumFavorite(_ album: AlbumModel) -> Bool {
        if let user = self.user {
            let favorites = user.user_profile.favorites
            return favorites.contains(album.id)
        } else {
            return false
        }
    }
    public func likeTrack(_ track: TrackModel) {
        if self.likedTracks[track.album_id] == nil {
            self.likedTracks[track.album_id] = [track.id: true]
        } else {
            self.likedTracks[track.album_id]![track.id] = true
        }
    }
    public func removeFavorite(_ album: AlbumModel) {
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
        self.ratings[album.id] = rating
    }
    public func unlikeTrack(_ track: TrackModel) {
        if self.likedTracks[track.album_id] != nil {
            self.likedTracks[track.album_id]![track.id] = nil
        }
    }
}
