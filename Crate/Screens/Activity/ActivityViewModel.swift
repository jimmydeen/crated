import Foundation
import Observation

@Observable class ActivityViewModel: UserViewModel {
    var activities: [ActivityModel] = []
    
    public func fetchActivities() async {
        activities.removeAll()
        
        do {
            activities = try await user.retrieveActivities()
        } catch {
            activities = []
            print(error)
        }
    }
    
    private enum ActivitiesError: Error {
        case emptyActivities
    }
}
