import Foundation
import CoreData

extension UserModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModel> {
        return NSFetchRequest<UserModel>(entityName: "UserModel")
    }

    @NSManaged public var date_joined: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var user_profile: ProfileModel
}

extension UserModel : Identifiable { }
