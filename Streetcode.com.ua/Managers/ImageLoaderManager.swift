//
//  ImageDecoder.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI

protocol ImageLoadableType {
    func loadImage(imageId: Int) async -> Image?
}

final class ImageLoaderManager: ImageLoadableType, ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    private let networkManager: WebAPIManagerProtocol
    let imageDecoder: ImageDecoderable
    
    init(networkManager: WebAPIManagerProtocol, imageDecoder: ImageDecoderable) {
        self.networkManager = networkManager
        self.imageDecoder = imageDecoder
    }

    func loadImage(imageId: Int) async -> Image? {
        let request = CatalogRequest.getCatalogImage(id: imageId)
        var cacheKey = NSString()
        
        if let urlString = request.urlAbsolute?.absoluteString {
            cacheKey = NSString(string: urlString)
        }
        
        guard let cacheImage = self.cache.object(forKey: cacheKey) else {
            if let image = await image(for: request) {
                self.cache.setObject(image, forKey: cacheKey)
                return Image(uiImage: image)
            } else {
                return nil
            }
        }
        return Image(uiImage: cacheImage)
    }
    
    private func image(for request: CatalogRequest) async -> UIImage? {
        let result: Result<CatalogImage, APIError> = await networkManager.perform(request)

        switch result {
        case .success(let imageModel):
          return imageModel.base64.base64Image
        case .failure:
          print("ImageLoaderManager: Can't download image by URL: \"\(String(describing: request.urlAbsolute))\"")
          return nil
        }
    }
}

extension String {
  var base64Image: UIImage? {
    guard let data = Data(base64Encoded: self) else { return nil }

    return UIImage(data: data)
  }
}
