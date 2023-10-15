//
//  ImageCell.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 10/10/2023.
//

import SwiftUI

struct ImageCell: View {
    let imageURL: String?
    let imageId: Int?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Group {
                if let imageId = imageId {
                    Text("\(imageId)")
                        .font(.system(.headline))
                } else {
                    Text("ImageId missing")
                }
            }
            .padding(.leading, 10)
            .frame(minWidth: 30)
            
            if let imageURL = imageURL {
                VStack(alignment: .center) {
                    AsyncImageUI(urlString: imageURL,
                                 placeholder: UIImage(named: "placeholder"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 180)
                }
            }
        }
    }
}

struct ImageCell_Previews: PreviewProvider {
    static var previews: some View {
        ImageCell(imageURL: "https://zipoapps-storage-test.nyc3.digitaloceanspaces.com/17_4691_besplatnye_kartinki_volkswagen_golf_1920x1080.jpg",
                  imageId: 1)
    }
}
