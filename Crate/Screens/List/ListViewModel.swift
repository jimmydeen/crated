import Foundation
import Observation

@Observable class ListViewModel {
    var list: ListModel
    
    init(list: ListModel) {
        self.list = list
    }
}
