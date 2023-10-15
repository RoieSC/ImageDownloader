//
//  ImagesService.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 10/10/2023.
//

import Foundation

protocol ImagesServiceProtocol {
    func getImages() async -> Result<[ImageData], RequestError>
}

struct ImagesService: ImagesServiceProtocol, HTTPClient {
    let endpoint = "https://zipoapps-storage-test.nyc3.digitaloceanspaces.com/image_list.json"
    func getImages() async -> Result<[ImageData], RequestError> {
        await fetchData(urlString: endpoint,
                        responseModel: [ImageData].self)
    }
}
