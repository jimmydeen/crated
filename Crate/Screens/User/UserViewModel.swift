import Foundation
import Observation

@Observable class UserViewModel {
    private(set) var user: User
    
    init(user: User) {
        self.user = user
    }
}
