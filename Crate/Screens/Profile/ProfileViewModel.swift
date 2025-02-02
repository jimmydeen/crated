import Foundation
import Observation

@Observable class ProfileViewModel {
    private let user: UserService = .shared
    
    private(set) var friends: [User] = []
    
    private var canLoadMorePages: Bool = true
    private var page: Int = 1
    private var searchTask: Task<Void, Never>? = nil
    
    var username: String {
        return user.user?.username ?? "unknown"
    }
    
    var avatar: URL? {
        if let avatar = user.user?.avatar {
            return URL(string: avatar)
        } else {
            return nil
        }
    }
    
    func loadInitialFriends() async {
        searchTask?.cancel()
        searchTask = nil
        friends.removeAll()
        canLoadMorePages = true
        page = 1
        
        searchTask = Task {
            if Task.isCancelled { return }
            await fetchFriends()
        }
    }
    
    func loadMoreFriends(currentItem: User) {
        guard canLoadMorePages else { return }
        
        if friends.count >= 3, friends[friends.count - 3].id == currentItem.id {
            searchTask = Task {
                await fetchFriends()
            }
        }
    }
    
    private func fetchFriends() async {
        do {
            let friends = try await user.retrieveFriends(page: page)
            
            if Task.isCancelled { return }
            self.friends += friends
            
            if friends.count < 10 {
                canLoadMorePages = false
            }
            page += 1
        } catch {
            if Task.isCancelled { return }
            print(error)
        }
    }
}
