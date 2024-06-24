//
//  DiscoveryCollectionViewCell.swift
//  Crate
//
//  Created by JD Chiang on 25/6/2024.
//

import UIKit

class DiscoveryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DiscoveryCollectionViewCell"
    
    private let myImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
}
