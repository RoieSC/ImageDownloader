//
//  ImageData.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 10/10/2023.
//

import Foundation

struct ImageData: Identifiable, Decodable {
    let id: Int?
    let imageUrl: String?
}
