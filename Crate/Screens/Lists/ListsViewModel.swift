import Foundation
import Observation

@Observable class ListsViewModel {
    var lists: [ListModel] = []
    
    let userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    
    func fetchLists() async {
        
    }
}
