# ImageDownloader
A simple to use images downloader with cache management.

**Usage:**

SwiftUI
-------
AsyncImageUI(urlString: String)
AsyncImageUI(urlString: String, placeholder: UIImage?, cacheValidTimeInterval: TimeInterval))

UIKit
-----
@IBOutlet weak var asyncImageView: AsyncImageView!
asyncImageView.loadImage(urlString: String)
asyncImageView.loadImage(urlString: String, placeholder: UIImage?, cacheValidTimeInterval: TimeInterval)

// placeholder & cacheValidTimeInterval are optional. cacheValidTimeInterval default is 4 hours (SwiftUI & UIKit)
