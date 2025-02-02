import Foundation
import Observation

@Observable class ActivityViewModel {
    private let user: UserService = .shared
    
    private(set) var activities: [Activity] = []
    
    func fetchActivities() async {
        do {
            activities = try await user.retrieveActivities()
        } catch {
            activities = []
            print(error)
        }
    }
}
