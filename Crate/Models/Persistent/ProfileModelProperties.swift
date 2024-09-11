import Foundation
import CoreData

extension ProfileModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileModel> {
        return NSFetchRequest<ProfileModel>(entityName: "ProfileModel")
    }

    @NSManaged public var favorites: NSSet
    @NSManaged public var id: UUID
    @NSManaged public var profile_user: UserModel
}

extension ProfileModel : Identifiable { }
