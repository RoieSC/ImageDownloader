//
//  ImageCacheValidation.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 09/10/2023.
//

import UIKit

actor ImagesCacheManager {
    
    static let shared = ImagesCacheManager()
    let loadDatesDictFileName = "loadImagesDatesDictionary"
    private var loadDateDict: Dictionary<URL, Date>?
    
    var imagesCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 300 * 1024 * 1024 // 300mb
        return cache
    }()
    
    private init() {
        loadDateDict = try? Dictionary<URL, Date>.read(from: loadDatesDictFileName)
    }
    
    func setImageCache(image: UIImage, url: URL) {
        imagesCache.setObject(image, forKey: url.absoluteString as NSString)
        persistImage(image, for: url)
    }
    
    func getImageFromCache(url: URL) -> UIImage? {
        if let image = imagesCache.object(forKey: url.absoluteString as NSString) { //Get image from NSCache
            return image
        } else {
            guard let image = imageFromFileSystem(for: url) else { return nil } //Get image from FileManager
            imagesCache.setObject(image, forKey: url.absoluteString as NSString) //Save image to NSCache
            return image
        }
    }
    
    //MARK: Invalidate Cache
    func saveLoadDate(url: URL) {
        if loadDateDict != nil {
            loadDateDict?[url] = Date()
        } else {
            loadDateDict = [url: Date()]
        }
        
        do {
            try loadDateDict?.write(to: loadDatesDictFileName)
        } catch {
            print("Error saving image load date: \(error.localizedDescription)")
        }
    }
    
    func removeCachedImageIfNeeded(url: URL,
                                   cacheValidTimeInterval: TimeInterval) -> Bool {
        if let loadDateDict = loadDateDict,
           let loadImageDate = loadDateDict[url] {
            let timeIntervalSinceLoadImage = Date().timeIntervalSince(loadImageDate)
            if timeIntervalSinceLoadImage > cacheValidTimeInterval {
                removeImageFromCache(url: url)
                return true
            }
        }
        return false
    }
    
    func invalidateCache() {
        guard let loadDateDict = self.loadDateDict else { return }
        
        //Invalidate cache
        imagesCache.removeAllObjects()
        for (url_, _) in loadDateDict {
            deleteImageFromFileSystem(url_)
        }
        
        //Save an empty load dates dictionary
        let emptyDict: [URL: Date] = [:]
        do {
            try emptyDict.write(to: loadDatesDictFileName)
        } catch {
            print("Error saving emptyDict: \(error.localizedDescription)")
        }
    }
    
    private func removeImageFromCache(url: URL) {
        imagesCache.removeObject(forKey: url.absoluteString as NSString)
        deleteImageFromFileSystem(url)
    }
    
    //MARK: - File system
    private func filePath(for url: URL) -> URL? {
        guard let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?.replacingOccurrences(of: "/", with: "") else { return nil }
        let directoryPath = FileManager.getDirectoryPath()
        return directoryPath.appendingPathComponent(fileName)
    }
    
    private func imageFromFileSystem(for url: URL) -> UIImage? {
        guard let filePath = filePath(for: url) else {
            assertionFailure("Unable to generate a local path for \(url)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: filePath)
            return UIImage(data: data)
        } catch {
            print("imageFromFileSystem fileName: \(filePath) error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func persistImage(_ image: UIImage, for url: URL) {
        guard let filePath = filePath(for: url),
              let data = image.jpegData(compressionQuality: 0.8) else {
            assertionFailure("Unable to generate a local path for \(url)")
            return
        }
        
        do {
            try data.write(to: filePath)
        } catch  {
            print("persistImage_ error saving image to disk: \(filePath) error: \(error.localizedDescription)")
        }
    }
    
    private func deleteImageFromFileSystem(_ url: URL) {
        guard let filePath = filePath(for: url) else { return }
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch  {
            print("deleteImage_ error deleting image at path: \(filePath)")
        }
    }
}

fileprivate extension Dictionary where Key: Codable, Value: Codable {
    func write(to fileName: String) throws {
        let filePath = FileManager.getDirectoryPath().appendingPathComponent(fileName)
        let data = try PropertyListEncoder().encode(self)
        try data.write(to: filePath)
    }
    
    static func read(from fileName: String) throws -> Dictionary<URL, Date> {
        let filePath = FileManager.getDirectoryPath().appendingPathComponent(fileName)
        let data = try Data(contentsOf: filePath)
        let dict = try PropertyListDecoder().decode(Dictionary<URL, Date>.self, from: data)
        return dict
    }
}

fileprivate extension FileManager {
    static func getDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return arrayPaths[0]
    }
}
