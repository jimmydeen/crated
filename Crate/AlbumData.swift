//
//  AlbumData.swift
//  Crate
//
//  Created by JD Chiang on 23/4/2023.
//

import UIKit

class AlbumData: NSObject, Decodable {
    var spotifyId: String
    var coverURL: String?
    var title: String
    var releaseDate: String
    var artistNames: String?
    var albumType: String
    var trackName: String?
    var genreNames: String?
    var spotifyURL: String
    var upc: String?
    var ean: String?
    var label: String?
    
    private enum RootKeys: String, CodingKey {
        case albumType = "album_type"
        case external_urls
        case spotifyId = "id"
        case images
        case title = "name"
        case releaseDate = "release_date"
        case external_ids
        case genres
        case label
        case artists
        case tracks
    }
    
    private enum SpotifyKeys: String, CodingKey {
        case spotifyURL = "spotify"
    }
    
//    private enum ImageKeys: String, CodingKey {
//        case coverURL = "url"
//    }
    
//    private enum ArtistKeys: String, CodingKey {
//        case artistNames = "name"
//    }
    
//    private enum TrackKeys: String, CodingKey {
//        case items
//
//    }
//
//    private enum TrackDetailKeys: String,CodingKey {
//        case artists
//        case trackName = "name"
//    }
    
    private enum ExternalURLKeys: String, CodingKey {
        case spotify
    }
//
    private enum IdKeys: String, CodingKey {
        case upc
        case ean
    }
    
    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
//        let imageContainer = try rootContainer.nestedContainer(keyedBy: ImageKeys.self, forKey: .images)
        albumType = try rootContainer.decode(String.self, forKey: .albumType)
//        let tracksRootContainer = try rootContainer.nestedContainer(keyedBy: TrackKeys.self, forKey: .tracks)
//        let trackContainer = try tracksRootContainer.nestedContainer(keyedBy: TrackDetailKeys.self, forKey: .items)
//        let artistContainer = try? rootContainer.nestedContainer(keyedBy: ArtistKeys.self, forKey: .artists)
        if let artistArray = try? rootContainer.decode([Artist].self, forKey: .artists){
            var artistNamesArray: [String] = []
            for artist in artistArray {
                artistNamesArray.append(artist.name)
            }
            artistNames = artistNamesArray.joined(separator: ", ")
        }
        let idContainer = try? rootContainer.nestedContainer(keyedBy: IdKeys.self, forKey: .external_ids)
        

        if let genreArray = try? rootContainer.decode([String].self, forKey: .genres){
            if !genreArray.isEmpty {
                genreNames = genreArray.joined(separator: ", ")
            }
        }
        spotifyId = try rootContainer.decode(String.self, forKey: .spotifyId)
        let externalURLContainer = try rootContainer.nestedContainer(keyedBy: ExternalURLKeys.self, forKey: .external_urls)
        spotifyURL = try externalURLContainer.decode(String.self, forKey: .spotify)
//        spotifyURL = try rootContainer.decode(String.self, forKey: .external_urls)
//        let imageArray = try imageContainer.decode([String].self, forKey: .coverURL)
        //Get largest cover
//        coverURL = imageArray[0]
        
        coverURL = try rootContainer.decode([Image].self, forKey: .images).first?.url
        
        guard coverURL != nil else {
            throw InitError.missingCoverURL
        }
        label = try rootContainer.decode(String.self, forKey: .label)
        title = try rootContainer.decode(String.self, forKey: .title)
        releaseDate = try rootContainer.decode(String.self, forKey: .releaseDate)
        ean = try? idContainer?.decode(String.self, forKey: .ean)
        upc = try? idContainer?.decode(String.self, forKey: .upc)
        
        
        
        
        
        
            
        
        
    }
    
    func getBookCover() {
        
    }
    
    /* func setBookCover(imageURL: String){
        let requestURL = URL(string: imageURL)!
        Task {
            print("Downloading image: " + imageURL)
            imageDownloading = true
            do {
                let (data, response) = try await URLSession.shared.data(from: requestURL)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    imageDownloading = false
                    throw LoadCoverError.invalidServerResponse
                }
                
                if let image = UIImage(data: data) {
                    print("Image downloaded")
                    bookCover.image = image
                    await MainActor.run {
                    }
                }
                else {
                    print("Image invalid")
                    imageDownloading = false
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    } */
    
    func downloadCover(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        let requestURL = URL(string: imageURL)!
        Task {
            print("Downloading image" + imageURL)
            do {
                let (data, response) = try await URLSession.shared.data(from: requestURL)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw LoadCoverError.invalidServerResponse
                }
                
                if let image = UIImage(data: data) {
                    print("Image download successful")
                    completion(image)
                    
                } else {
                    
                    print("Image invalid")
                    throw LoadCoverError.invalidImage
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
