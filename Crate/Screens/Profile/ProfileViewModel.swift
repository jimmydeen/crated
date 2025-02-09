import Foundation
import Observation

@Observable class ProfileViewModel {
    private let batchSize: Int = 10
    private let user: UserService = .shared
    
    private(set) var friends: [User] = []
    private(set) var isUserLoaded: Bool = false
    private(set) var profile: User?
    
    private var canLoadMorePages: Bool = true
    private var page: Int = 1
    private var searchTask: Task<Void, Never>? = nil
    
    func fetchUser() async {
        do {
            profile = try await user.retrieveUser()
            isUserLoaded = true
        } catch {
            print(error)
        }
    }
    
    func loadInitialFriends() async {
        searchTask?.cancel()
        searchTask = nil
        canLoadMorePages = true
        page = 1
        
        searchTask = Task {
            if Task.isCancelled { return }
            await fetchFriends()
        }
    }
    
    func loadMoreFriends(currentItem: User) {
        guard canLoadMorePages else { return }
        
        if friends.count >= 1, friends[friends.count - 1].id == currentItem.id {
            searchTask = Task {
                await fetchFriends()
            }
        }
    }
    
    private func fetchFriends() async {
        do {
            let friends = try await user.retrieveFriends(page: page, batchSize: batchSize)
            
            if Task.isCancelled { return }
            self.friends += friends
            
            if friends.count < batchSize {
                canLoadMorePages = false
            }
            page += 1
        } catch {
            if Task.isCancelled { return }
            print(error)
        }
    }
}
