//
//  SearchTableViewController.swift
//  Crate
//
//  Created by JD Chiang on 24/4/2023.
//

import UIKit
import Kingfisher




enum HrefError: Error {
    case MissingURL
}

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    let placeholder = UIImage(named: "placeholdergrey.png")
    let clientID = "3df19c42306e4256863747c6f43bb7b3"
    let clientSecret = "a94ede4677104b38a3c98333ac4c801c"
    let baseURL = "https://api.spotify.com/v1"
    
    let ALBUM_SCOPE = 0
    let ARTIST_SCOPE = 1
    
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    
    var currentRequestIndex: Int = 0
    let CELL_ALBUM = "albumCell"
    let REQUEST_STRING_HEAD = "https://api.spotify.com/v1/search?query="
    let REQUEST_STRING_TAIL = "&type=album&market=AU&locale=en-US%2Cen%3Bq%3D0.9%2Cko%3Bq%3D0.8&offset=0&limit=20"
    
    var newAlbums = [SimpleAlbumData]()
    var indicator = UIActivityIndicatorView()
    
    var delegate: AlbumDetailsDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["Albums", "Artists"]
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
        indicator.centerXAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.centerXAnchor),
        indicator.centerYAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newAlbums.count
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
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ALBUM, for: indexPath)
        let album = newAlbums[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = album.name
        content.secondaryText = album.artistNames
        content.image = UIImage(named: "placeholdergrey")
        cell.contentConfiguration = content
        if let coverURL = URL(string: album.coverURL!) {
                // Set a placeholder image while the actual image is being downloaded
//            UIImage(named: )
                
                
                downloadImage(from: coverURL) { image in
                    DispatchQueue.main.async {
                        content.image = image
                        cell.contentConfiguration = content
                        cell.setNeedsLayout()
                    }
                }
            }

        
        
//        cell.textLabel
//        content.secondaryText = album.artistNames
//        let url = URL(string: album.coverURL)
//        content.image
//        content.image = imageView.kf.setImage(with: url, placeholder: nil)
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = newAlbums[indexPath.row]
        let apiLink = album.href
//        getFullAlbum(href: apiLink)
        
        
        delegate?.sendAlbumDetails(albumURL: apiLink)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let albumDetailsView = segue.destination as! AlbumDetailsViewController
            self.delegate = albumDetailsView
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    func requestAlbumsNamed(_ albumName: String,_ scope: String) async {

       
        
        
       

        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.spotify.com"
        searchURLComponents.path = "/v1/search"
        searchURLComponents.queryItems = [
            //search for albums only
            URLQueryItem(name: "q", value: "\(albumName)"),
            URLQueryItem(name: "type", value: "\(scope)"),
            URLQueryItem(name: "limit", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "offset", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)")
            
        ]
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }

        do {
            let accessToken = try await authenticate()
            
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
                newAlbums.append(contentsOf: albums)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                if albums.count == MAX_ITEMS_PER_REQUEST,
                    currentRequestIndex + 1 < MAX_REQUESTS {
                    currentRequestIndex += 1
                    await requestAlbumsNamed(albumName, scope)
                }
            }
            
        }
        catch let error {
            print(error)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        newAlbums.removeAll()
        tableView.reloadData()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        let scope: String
        if searchBar.selectedScopeButtonIndex == ALBUM_SCOPE {
            scope = "album"
        } else {
            scope = "artist"
        }
        
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        Task {
            URLSession.shared.invalidateAndCancel()
            currentRequestIndex = 0
            await requestAlbumsNamed(searchText, scope)
        }
    }
    
    func authenticate() async throws -> String {
        
        enum SpotifyError: Error {
            case authenticationFailed
        }
        let authURL = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: authURL)
        
        request.httpMethod = "POST"
        let authData = "\(clientID):\(clientSecret)".data(using: .utf8)
        let authString = authData?.base64EncodedString()
        request.addValue("Basic \(authString ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SpotifyError.authenticationFailed
        }
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        guard let accessToken = json["access_token"] as? String else {
            throw SpotifyError.authenticationFailed
        }
        print("token:", accessToken)
        return accessToken
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBarTextDidEndEditing(searchBar)
        print("scope is \(selectedScope)")
    }
//    func getAlbumCover(imageURL: String){
//        let requestURL = URL(string: imageURL)!
//        Task {
//            print("Downloading image: " + imageURL)
////            imageDownloading = true
//            do {
//                let (data, response) = try await URLSession.shared.data(from: requestURL)
//                guard let httpResponse = response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200 else {
////                    imageDownloading = false
//                    throw LoadCoverError.invalidServerResponse
//                }
//
//                if let image = UIImage(data: data) {
//                    print("Image downloaded")
//                    return image
////                    bookCover.image = image
//                    await MainActor.run {
//                    }
//                }
//                else {
//                    print("Image invalid")
////                    imageDownloading = false
//                }
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//

}





   
        
