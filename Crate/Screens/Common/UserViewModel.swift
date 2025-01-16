import Foundation
import Observation

@Observable class UserViewModel {
    let user: UserService = .shared
    
    var isAuthenticated: Bool {
        user.isAuthenticated
    }
}
