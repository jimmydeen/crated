//
//  AddSearchCell.swift
//  Crate
//
//  Created by JD Chiang on 22/6/2024.
//

import UIKit
import Foundation

class AddSearchCell: UICollectionViewCell {
    
    static let id = "AddAlbumCell"
    private var album_cover_view: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(album_cover_view)
        configure_ui()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddSearchCell  {
    func configure_ui() {
        album_cover_view.translatesAutoresizingMaskIntoConstraints = false
        album_cover_view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        album_cover_view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        album_cover_view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        album_cover_view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
//    
    func update_cell(aart_url: String?) {
//        if let aart_url = aart_url {
////            TO DO: Add IMG Address
////            guard let complete_url = URL(string: )
//        }
    }
}
