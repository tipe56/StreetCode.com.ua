//
//  CatalogRemoteImage.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 28.12.23.
//
//
import SwiftUI

struct CatalogRemoteImage: View {
    let imageLoader: ImageLoadableType?
    let imageId: Int
    var imagePlaceholder: Image
    @State private var progressViewModel: ProgressImageView.ViewModel?
    
    init(imageLoader: ImageLoadableType?,
         imageId: Int,
         imagePlaceholder: Image = Image("catalog-placeholder")) {
        self.imageLoader = imageLoader
        self.imageId = imageId
        self.imagePlaceholder = imagePlaceholder
    }
    
    var body: some View {
        ProgressImageView(viewModel: progressViewModel)
            .onAppear {
                Task {
                    let image = await imageLoader?.loadImage(imageId: imageId)
                    withAnimation {
                        self.progressViewModel = .init(image:image == nil ? imagePlaceholder : image,
                                                       offsetY: image == nil ? 0 : 35)
                    }
                }
            }
    }
}


