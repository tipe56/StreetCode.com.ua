//
//  CatalogRemoteImage.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 28.12.23.
//

import SwiftUI

struct RemoteImage: View {
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("catalog-placeholder").resizable()
    }
}

struct CatalogRemoteImage: View {
    let imageLoader: ImageLoaderable?
    let imageId: Int
    @State var image: Image?
    
    var body: some View {
        RemoteImage(image: image)
            .onAppear {
                Task {
                   let image = await imageLoader?.loadImage(imageId: imageId)
                    await MainActor.run {
                        self.image = image
                    }
                }
            }
    }
}
