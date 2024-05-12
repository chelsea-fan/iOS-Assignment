//
//  Models.swift
//  iOS Assignment
//
//  Created by Swarandeep on 12/05/24.
//

import Foundation

struct ContentData: Codable {
    let id: String?
    let title: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    let domain: String?
    let basePath: String?
    let key: String?
    let id: String?
}
