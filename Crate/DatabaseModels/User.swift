////
////  User.swift
////  Crate
////
////  Created by JD Chiang on 24/5/2023.
////
//
import UIKit

class User: NSObject {
    var userId: String?
    var displayName: String?
    var userEmail: String?
    var userName: String?
    init(userId: String? = nil, displayName: String? = nil, userEmail: String? = nil) {
        self.userId = userId
        self.displayName = displayName
        self.userEmail = userEmail
//        self.userName = userName
    }
    
}
