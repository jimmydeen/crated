import Foundation

class UserModel: NSObject {
    let user_id: String = UUID().uuidString
    let user_displayname: String
    let user_name: String
    let user_email: String
    
    init(user_displayname: String, user_name: String, user_email: String) {
        self.user_displayname = user_displayname
        self.user_name = user_name
        self.user_email = user_email
    }
}
