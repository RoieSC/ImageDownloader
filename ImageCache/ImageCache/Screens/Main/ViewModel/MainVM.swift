//
//  MainVM.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 10/10/2023.
//

import Foundation
import Combine

class MainVM: ObservableObject {
    @Published private(set) var images: [ImageData] = []
    let service = ImagesService()
    
    init() {
        Task {
            await fetchImages()
        }
    }
    
    private func fetchImages() async {
        let result = await service.getImages()
        switch result {
        case .success(let response):
            await setImages(images: response)
        case .failure(let error):
            print("Error fetching images: \(error)")
        }
    }
    
    private func setImages(images: [ImageData]) async {
        await MainActor.run {
            self.images = images
        }
    }
    
    //MARK: - Input
    func invalidateCache() async {
        await ImagesCacheManager.shared.invalidateCache()
    }
}
