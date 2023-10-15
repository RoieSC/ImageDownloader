//
//  AsyncImageView.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 08/10/2023.
//

import UIKit
import Combine

class AsyncImageView: UIImageView {
    private var imageDownloader: ImageDownloader?
    private var cancellable: AnyCancellable?
    
    func loadImage(urlString: String?,
                   placeholder: UIImage? = nil,
                   cacheValidTimeInterval: TimeInterval = ImageDownloader.defaultCacheValidTimeInterval) {
        guard let urlString = urlString else {
            image = placeholder
            return
        }
        
        imageDownloader = ImageDownloader(
            url: URL(string: urlString),
            placeholder: placeholder,
            cacheValidTimeInterval: cacheValidTimeInterval
        )
        
        observeImage()
    }
    
    private func observeImage() {
        cancellable = imageDownloader?.$image.sink { [weak self] image in
            self?.image = image
        }
    }
}
