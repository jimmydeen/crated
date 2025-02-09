import Foundation
import Observation

@Observable class UserViewModel {
    private let user: UserService = .shared
    
    private(set) var profile: User
    
    init(profile: User) {
        self.profile = profile
    }
    
    func sendFriendRequest() {
        Task {
            do {
                try await user.sendFriendRequest(user_id: profile.id)
            } catch {
                print(error)
            }
        }
    }
}
