//
//  ImageDownloader.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 08/10/2023.
//

import UIKit

class ImageDownloader: ObservableObject {
    
    let url: URL?
    let placeholder: UIImage?
    let cacheValidTimeInterval: TimeInterval
    let cacheManager = ImagesCacheManager.shared
    static let defaultCacheValidTimeInterval: TimeInterval = 4*3600
    @Published private(set) var image: UIImage?
    
    init(url: URL?,
         placeholder: UIImage? = nil,
         cacheValidTimeInterval: TimeInterval = ImageDownloader.defaultCacheValidTimeInterval) {
        self.url = url
        self.placeholder = placeholder
        self.cacheValidTimeInterval = cacheValidTimeInterval
        Task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        await setImage(placeholder)
        
        guard let url = url else { return }
        
        if await !cacheManager.removeCachedImageIfNeeded(url: url, cacheValidTimeInterval: cacheValidTimeInterval),
           let cachedImage = await cacheManager.getImageFromCache(url: url) {
            await setImage(cachedImage)
//            print("got image from cache url: \(url)")
            return
        }
        
        do {
            guard let image = try await downloadImage(url: url) else { return }
            await setImage(image)
//            print("got image from web url: \(url)")
            await cacheManager.setImageCache(image: image, url: url)
            await cacheManager.saveLoadDate(url: url)
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
        }
    }
    
    private func setImage(_ image: UIImage?) async {
        await MainActor.run {
            self.image = image
        }
    }
    
    private func downloadImage(url: URL) async throws -> UIImage? {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard url == response.url else {
                print("downloadImage_ wrong url in response: \(String(describing: response.url))")
                return nil
            }
            guard let image = UIImage(data: data) else { return nil }
            return image
        } catch {
            throw error
        }
    }
}
