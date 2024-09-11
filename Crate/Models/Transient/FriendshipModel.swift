import Foundation

class FriendshipModel: NSObject {
    let id: UUID
    let user_id_A: String
    let user_id_B: String
    let friend_status: String
    
    init(user_id_A: String, user_id_B: String, friend_status: String, id: UUID?) {
        self.user_id_A = user_id_A
        self.user_id_B = user_id_B
        self.friend_status = friend_status
        self.id = id ?? UUID()
    }
}
