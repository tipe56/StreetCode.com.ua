//
//  CatalogRemoteImage.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 28.12.23.
//

import SwiftUI

struct CatalogRemoteImage: View {
    let imageLoader: ImageLoaderable?
    let imageId: Int
    let imagePlaceholder: Image
    @State private var image: Image?
    @State var isFailLoading: Bool
    
    var body: some View {
        Group {
            if isFailLoading {
                imagePlaceholder.resizable()
            } else {
                catalogImage
            }
        }
        .onAppear {
            Task {
                let image = await imageLoader?.loadImage(imageId: imageId)
                await MainActor.run {
                    withAnimation {
                        self.image = image
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var catalogImage: some View {
        if let image {
            image
                .resizable()
                .offset(y: 35)
        } else {
            ProgressView()
        }
    }
}


