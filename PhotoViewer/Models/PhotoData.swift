//
//  PhotoData.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 30.08.2023.
//

import Foundation

struct Photo: Codable, Equatable {
    let urls: URLs?
    let user: User?
    let id: String?
    let created_at: String?
    let likes: Int?
    let width: Int?
    let height: Int?
}

struct URLs: Codable, Equatable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct User: Codable, Equatable {
    let username: String?
    let name: String?
    let location: String?
}
