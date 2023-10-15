//
//  ImageUI.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 08/10/2023.
//

import SwiftUI

struct AsyncImageUI: View {
    @StateObject private var imageDownloader: ImageDownloader
    
    init(urlString: String,
         placeholder: UIImage? = nil,
         cacheValidTimeInterval: TimeInterval = ImageDownloader.defaultCacheValidTimeInterval) {
        _imageDownloader = StateObject(wrappedValue: ImageDownloader(
            url: URL(string: urlString),
            placeholder: placeholder,
            cacheValidTimeInterval: cacheValidTimeInterval
        ))
    }
    
    var body: some View {
        Image(uiImage: imageDownloader.image ?? UIImage())
            .resizable()
    }
}

struct ImageUI_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageUI(urlString: "https://zipoapps-storage-test.nyc3.digitaloceanspaces.com/17_4691_besplatnye_kartinki_volkswagen_golf_1920x1080.jpg")
    }
}
