//
//  CollectionData.swift
//  Crate
//
//  Created by JD Chiang on 23/4/2023.
//
//
//import UIKit
//
//
//
//class CollectionData: NSObject, Decodable {
//
////    required init(from decoder: Decoder) throws {
////        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
////        let nestedContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .albums)
////
////        albumList = try? nestedContainer.decode([AlbumData].self, forKey: .albumList)
////        }
//
////    private enum RootKeys: String, CodingKey {
////        case albums
////    }
////
//    private enum CodingKeys: String, CodingKey {
//        case albumList = "items"
//    }
//
//    var albumList: [AlbumData]?
//}
