//
//  AlbumDetailsViewController.swift
//  Crate
//
//  Created by JD Chiang on 7/5/2023.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class AlbumDetailsViewController: UIViewController, AlbumDetailsDelegate {
   
    var indicator = UIActivityIndicatorView()
    
    var albumUrl: String?
    
 
    
    @IBOutlet weak var albumCover: UIImageView!
    
    @IBOutlet weak var albumTitle: UILabel!
    
    @IBOutlet weak var artistNames: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var albumType: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var ean: UILabel!
    
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
        
   

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.startAnimating()
        Task {
            URLSession.shared.invalidateAndCancel()
            if let albumUrl {
                await getAlbumDetails(albumURL: albumUrl)
            }
        }
    }
    
    func sendAlbumDetails(albumURL: String) {
        self.albumUrl = albumURL
    }
    
    func getAlbumDetails(albumURL: String) async {
        
        guard let requestURL = URL(string: albumURL) else {
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
            
            
            let album = try decoder.decode(AlbumData.self, from: data)
            
            if let coverURL = URL(string: album.coverURL!) {
                    // Set a placeholder image while the actual image is being downloaded
    //            UIImage(named: )
                    
                    
                    downloadImage(from: coverURL) { image in
                        DispatchQueue.main.async {
                            self.albumCover.image = image
                        }
                    }
                }
            setAlbumDetails(album: album)
            
////            print(collectionData.albums)
//            if let albums = searchResponse.albumList {
////                print(albums)
//                newAlbums.append(contentsOf: albums)
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                if albums.count == MAX_ITEMS_PER_REQUEST,
//                    currentRequestIndex + 1 < MAX_REQUESTS {
//                    currentRequestIndex += 1
//                    await requestAlbumsNamed(albumName, scope)
//                }
//            }
            
        }
        catch let error {
            print(error)
        }
    }
    
    func setAlbumDetails(album: AlbumData) {
        guard let artists = album.artistNames else {
            return
        }

        albumTitle.text = album.title
        artistNames.text = artists
        releaseDate.text = album.releaseDate
        albumType.text = album.albumType
        label.text = album.label
//        if let albumUpc = album.upc, !albumUpc.isEmpty{
//            upc.text = albumUpc
//            upc.numberOfLines = 0
//        }
        
        if let albumEan = album.ean, !albumEan.isEmpty{
            ean.text = albumEan
            ean.numberOfLines = 0
        }
        
        albumTitle.numberOfLines = 0
        artistNames.numberOfLines = 0
        releaseDate.numberOfLines = 0
        albumType.numberOfLines = 0
        
        

    }
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
    
}
