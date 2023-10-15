//
//  Review.swift
//  Crate
//
//  Created by JD Chiang on 12/5/2023.
//

import UIKit

class Review: NSObject {
    var reviewId: String?
    
    var albumId: String?
    var userId: String?
    var userDisplayName: String?
    var ratingValue: Int?
    var reviewDescription: String?
    
    init(reviewId: String? = nil, albumId: String? = nil, userId: String? = nil, userDisplayName: String? = nil, ratingValue: Int? = nil, reviewDescription: String? = nil) {
        self.reviewId = reviewId
        self.albumId = albumId
        self.userId = userId
        self.userDisplayName = userDisplayName
        self.ratingValue = ratingValue
        self.reviewDescription = reviewDescription
    }
   
}
