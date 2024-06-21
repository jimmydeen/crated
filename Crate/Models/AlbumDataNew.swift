//
//  AlbumData.swift
//  Crate
//
//  Created by JD Chiang on 22/6/2024.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [album_data]
}

struct album_data: Codable {
    let id: Int
    let aart_path: String?
    let release_date: String?
}

