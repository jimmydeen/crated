import Foundation

class FriendshipModel: NSObject {
    let id: UUID
    let user_id_A: UUID
    let user_id_B: UUID
    
    init(user_id_A: UUID, user_id_B: UUID, id: UUID = UUID()) {
        self.user_id_A = user_id_A
        self.user_id_B = user_id_B
        self.id = id
    }
}
