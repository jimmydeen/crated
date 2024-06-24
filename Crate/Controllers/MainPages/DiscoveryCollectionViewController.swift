//
//  DiscoveryCollectionViewController.swift
//  Crate
//
//  Created by JD Chiang on 16/5/2023.
//

import UIKit



class DiscoveryCollectionViewController: UICollectionViewController {
    let CELL_IMAGE = "imageCell"
    let MAX_ITEMS_PER_REQUEST = 50
    let MAX_REQUESTS = 2
    
    let searchRegion = "AU"
    var currentRequestIndex: Int = 0
    var indicator = UIActivityIndicatorView()
    var albumList = [SimpleAlbumData]()
    var delegate: AlbumDetailsDelegate?

        
    //    var imagePathList =
    //    var managedObjectContent:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        collectionView.backgroundColor = .systemBackground
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return albumList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! AlbumCollectionViewCell
        let album = albumList[indexPath.row]
        cell.backgroundColor = .secondarySystemFill
        if let coverURL = URL(string: album.coverURL!) {
            // Set a placeholder image while the actual image is being downloaded
            //            UIImage(named: )
            
            
            downloadImage(from: coverURL) { image in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    //                        cell.contentConfiguration = content
                    //                        cell.setNeedsLayout()
                }
            }
        }
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
//     */
//     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//     }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let album = albumList[indexPath.row]
        let apiLink = album.href
        delegate?.sendAlbumDetails(albumURL: apiLink)
        collectionView.deselectItem(at: indexPath, animated: false)
        
    }
    func requestNewAlbums() async {
        
        
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.spotify.com"
        searchURLComponents.path = "/v1/browse/new-releases"
        searchURLComponents.queryItems = [
            
            URLQueryItem(name: "country", value: searchRegion),
            URLQueryItem(name: "limit", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "offset", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)")
            
        ]
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        do {
            let accessToken = try await Authenticator.authenticate()
            
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "GET"
            
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            
            let (data, response) =
            try await URLSession.shared.data(for: urlRequest)
            print("data:",String(describing: data), "response:", response)
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            let decoder = JSONDecoder()
            
            
            let searchResponse = try decoder.decode(SearchResponse.self, from: data)
            
            
            //            print(collectionData.albums)
            if let albums = searchResponse.albumList {
                //                print(albums)
                
                albumList.append(contentsOf: albums)
                
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                if albums.count == MAX_ITEMS_PER_REQUEST,
                   currentRequestIndex + 1 < MAX_REQUESTS {
                    currentRequestIndex += 1
                    await requestNewAlbums()
                }
            }
            
        }
        catch let error {
            print(error)
        }
    }

    func generateLayout() -> UICollectionViewLayout {
        let imageItemSize = NSCollectionLayoutSize(widthDimension:
        .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let imageItem = NSCollectionLayoutItem(layoutSize: imageItemSize)
        imageItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5,
        bottom: 5, trailing: 5)
        let imageGroupSize = NSCollectionLayoutSize(widthDimension:
        .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(1/3))
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
        imageGroupSize, subitems: [imageItem])
        let imageSection = NSCollectionLayoutSection(group: imageGroup)
        return UICollectionViewCompositionalLayout(section: imageSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.startAnimating()
        Task {
            do {
                URLSession.shared.invalidateAndCancel()
                currentRequestIndex = 0
                await requestNewAlbums()
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let albumDetailsView = segue.destination as! AlbumDetailsViewController
            self.delegate = albumDetailsView
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
