import Foundation
import FirebaseFirestore

class DataStoreService {
    static let shared = DataStoreService()
    private let firestore = Firestore.firestore()

    private init() {}
}
