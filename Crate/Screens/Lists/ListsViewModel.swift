import Foundation
import Observation

@Observable class ListsViewModel: UserViewModel {
    var lists: [ListModel] = []
    
    func fetchLists() async {
        lists.removeAll()
        do {
            lists = try await user.retrieveLists()
        } catch {
            print(error)
        }
    }
}
