//
//  SearchResponse.swift
//  Crate
//
//  Created by JD Chiang on 2/5/2023.
//


import Foundation

class SearchResponse: NSObject, Decodable {
    var albumList: [SimpleAlbumData]?
    
    private enum SearchResponseKeys: String, CodingKey {
        case albums
    }
    
    private enum AlbumsKeys: String, CodingKey {
        case items
    }

    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: SearchResponseKeys.self)
        let albumsContainer = try rootContainer.nestedContainer(keyedBy: AlbumsKeys.self, forKey: .albums)
        albumList = try albumsContainer.decode([SimpleAlbumData].self, forKey: .items)
    }
}



//class SearchResponse: NSObject, Decodable {
//    var albumList: [AlbumData]?
//
//    private enum SearchResponseKeys: String, CodingKey {
//        case albums
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case albumList = "items"
//    }
//
//    required init(from decoder: Decoder) throws {
//        let rootContainer = try decoder.container(keyedBy: SearchResponseKeys.self)
//        let albumContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .albums)
//
//        albumList = try albumContainer.decode([AlbumData].self, forKey: .albumList)
////        self.albumList = try rootContainer.decode([AlbumData].self, forKey: .albumList)
////        let albums = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .)
//
//
//        print(albumList?.count)
////        let albumContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .albums)
////        self.albumList = try albumContainer.decodeIfPresent([AlbumData].self, forKey: .albumList)
//    }
//    init(from decoder: Decoder) throws {
//        if let searchResponseContainer = try? decoder.container(keyedBy: SearchResponseKeys.self){
////            self.albums = try searchResponseContainer.decode([AlbumData].self, forKey: .albums)
//            if let albumContainer = try? searchResponseContainer.nestedContainer(keyedBy: AlbumsKeys.self, forKey: .albums) {
//                print("decoding albums object")
//                self.albums = try albumContainer.decode([AlbumData].self, forKey: .items )
//                print("decode search success")
//            }
//        }
//    }
//}

