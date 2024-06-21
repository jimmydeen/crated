//
//  AddSearchVC.swift
//  Crate
//
//  Created by JD Chiang on 21/6/2024.
//

import Foundation
import UIKit
import SwiftUI

class AddSearchVC : UICollectionViewController {
    
    private var albums = [album_data]()
    
    private var SearchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Enter name of album"
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()
    
    private var AlbumScrollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AddSearchCell.self, forCellWithReuseIdentifier: AddSearchCell.id)
        return cv
    }()
    
    func configureUI() {
        AlbumScrollView.translatesAutoresizingMaskIntoConstraints = false
        AlbumScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        AlbumScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        AlbumScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        AlbumScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Album Search"
        view.backgroundColor = .systemBackground
        SearchBar.searchResultsUpdater = self
        navigationItem.searchController = SearchBar
        view.addSubview(AlbumScrollView)
        AlbumScrollView.delegate = self
        AlbumScrollView.dataSource = self
        configureUI()
    }
}

extension AddSearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else{return}
    }
    
}

extension AddSearchVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddSearchCell.id, for: indexPath) as? AddSearchCell {
//            TODO: uncomment after implement
//            cell.update_cell(aart_url: <#T##String?#>)
            return cell
        }
        return UICollectionViewCell()
    }
}
