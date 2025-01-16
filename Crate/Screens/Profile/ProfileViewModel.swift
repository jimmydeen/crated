import Foundation
import Observation

@Observable class ProfileViewModel: UserViewModel {
    func fetchProfileURL() -> URL? {
        do {
            return try user.retrieveProfileURL()
        } catch {
            print(error)
            return nil
        }
    }
    func fetchUsername() -> String {
        do {
            return try user.retrieveName()
        } catch {
            print(error)
            return ""
        }
    }
}
