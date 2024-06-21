
//  FirebaseController.swift
//  Crate
//
////  Created by JD Chiang on 11/5/2023.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestoreSwift
//
//class FirebaseController: NSObject, DatabaseProtocol {
//    let DEFAULT_LIST_NAME = "Watchlist"
//    var listeners = MulticastDelegate<DatabaseListener>()
//    var defaultUser: User
////    var defaultList: UserList
//    
//    var reviewList: [Review]
//    var albumLists: [[Album]]
//    var authController: Auth
//    var database: Firestore
//    var userRef: CollectionReference?
//    var reviewRef: CollectionReference?
//    var listRef: CollectionReference?
//    var albumRef: CollectionReference?
//    var currentUser: FirebaseAuth.User?
//    
//    override init(){
//        FirebaseApp.configure()
//        authController = Auth.auth()
//        database = Firestore.firestore()
//        albumList = [Album]()
//        defaultList = UserList()
//        super.init()
//        
//        Task {
//            do {
//                let authDataResult = try await authController.signInAnonymously()
//                currentUser = authDataResult.user
//            }
//            catch {
//                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
//            }
//        }
//        self.setupAlbumListener()
//        
//        
//        
//        
//    }
//    func cleanup() {
//    
//    }
//    
//    func addListener(listener: DatabaseListener) {
//        listeners.addDelegate(listener)
//        if listener.listenerType == .list || listener.listenerType == .all {
//            listener.onListChange(change: .update, list: defaultList)
//                    } else if listener.listenerType == .album || listener.listenerType == .all {
////                        listener.on
//                    }
//        }
//        
//        func removeListener(listener: DatabaseListener) {
//            listeners.removeDelegate(listener)
//        }
//        
//        //    func addUser(userHandle: String) {
//        //        <#code#>
//        //    }
//        
//        func addReview(userHandle: String, rating: Int, description: String) {
//            <#code#>
//        }
//        func getAlbumByID(_ id: String) -> Album?
//        func setupAlbumListener()
//        func setupListListener()
//        func parseAlbumsSnapshot(snapshot: QuerySnapshot)
//        func parseListSnapshot(snapshot: QuerySnapshot)
//        
//        
//    }
//}
