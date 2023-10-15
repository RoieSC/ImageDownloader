//
//  ContentView.swift
//  ImageCache
//
//  Created by Roie Shimon Cohen on 08/10/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainVM = MainVM()
    
    var body: some View {
        NavigationView {
            List(mainVM.images) { imageData in
                ImageCell(imageURL: imageData.imageUrl,
                          imageId: imageData.id)
            }
            .navigationTitle("Images")
            .toolbar {
                Button {
                    Task {
                        await mainVM.invalidateCache()
                    }
                } label: {
                    Text("Invalidate")
                }

            }
            .listStyle(.plain)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
