import Foundation
import FirebaseFirestore

class DataStoreService {
    static let shared = DataStoreService()
    let db = Firestore.firestore()

    private init() {}
    
    func createUser() {
        let docRef = db.collection("users").document()
        docRef.setData([
            "name": "John Doe",
            "age": 30,
            "isAdmin": false
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added successfully!")
            }
        }
    }
    
    func fetchData() {
        let docRef = db.collection("users").document("user1")
        docRef.getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                print("Document data: \(data ?? [:])")
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    func updateData() {
        let docRef = db.collection("users").document("user1")
        docRef.updateData([
            "age": 31,
            "isAdmin": true
        ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document updated successfully!")
            }
        }
    }
    
    func deleteData() {
        let docRef = db.collection("users").document("user1")
        docRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document deleted successfully!")
            }
        }
    }
}
