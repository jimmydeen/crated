//
//  Album.swift
//  Crate
//
//  Created by JD Chiang on 14/6/2024.
//

import Foundation
import UIKit

class Album: NSObject {
    var album_id: Int
    var album_name: String?
//    var artist_names: [Artist]
    init(album_id: Int, album_name: String? = nil) {
        self.album_id = album_id
        self.album_name = album_name
    }
    
}
