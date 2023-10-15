//
//  SimpleAlbumData.swift
//  Crate
//
//  Created by JD Chiang on 2/5/2023.
//

import Foundation
//

import UIKit

enum LoadCoverError: Error {
    case invalidServerResponse
    case invalidImage
}

enum InitError: Error {
    case missingCoverURL
}



class SimpleAlbumData: NSObject, Decodable {
    var coverImage: UIImage?
    var spotifyId: String
    var coverURL: String?
    var name: String
    var href: String
    var artistNames: String?
    
    
    
    private enum RootKeys: String, CodingKey {
        
        case spotifyId = "id"
        case images
        case name
        case artists
        case href
        
    }
    

//    private enum ArtistKeys: String, CodingKey {
//        case artistNames = "name"
//    }

    
    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
//        let imageContainer = try rootContainer.nestedContainer(keyedBy: ImageKeys.self, forKey: .images)
//        let artistContainer = try? rootContainer.nestedContainer(keyedBy: ArtistKeys.self, forKey: .
        if let artistArray = try? rootContainer.decode([Artist].self, forKey: .artists){
            var artistNamesArray: [String] = []
            for artist in artistArray {
                artistNamesArray.append(artist.name)
            }
            artistNames = artistNamesArray.joined(separator: ", ")
        }
        
        spotifyId = try rootContainer.decode(String.self, forKey: .spotifyId)
        
        href = try rootContainer.decode(String.self, forKey: .href)
        name = try rootContainer.decode(String.self, forKey: .name)
 
        coverURL = try rootContainer.decode([Image].self, forKey: .images)[1].url
        
        guard coverURL != nil else {
            throw InitError.missingCoverURL
        }
//        let coverImage.image = downloadCover(imageURL: <#T##String#>)
        
//        coverImage = downloadCover(imageURL: coverURL)
//        let imageArray = try rootContainer.decode([Image].self, forKey: .images)
//        if let URL = imageArray.last?.url {
//            coverURL = URL
//        }
        
//        if let imageArray = try? rootContainer.decode([Image].self, forKey: .images){
//           coverURL = imageArray.last?.url
//        }

    
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
}
