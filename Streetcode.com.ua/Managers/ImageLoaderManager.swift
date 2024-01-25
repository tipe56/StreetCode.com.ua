//
//  ImageLoaderManager.swift
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
    private let logger: Loggering
    
    init(networkManager: WebAPIManagerProtocol, logger: Loggering) {
        self.networkManager = networkManager
        self.logger = logger
    }
    
    func loadImage(imageId: Int) async -> Image? {
        let request = CatalogRequest.getCatalogImage(id: imageId)
        var cacheKey = NSString()
        
        if let urlString = request.urlAbsolute?.absoluteString {
            cacheKey = NSString(string: urlString)
        }
        
        guard let cacheImage = self.cache.object(forKey: cacheKey) else {
            if let image = await imageForRequest(request) {
                self.cache.setObject(image, forKey: cacheKey)
                return Image(uiImage: image)
            } else {
                logger.log(level: .error, message: "There is no image or can't covert uiImage to Image", file: #file)
                return nil
            }
        }
        return Image(uiImage: cacheImage)
    }
    
    private func imageForRequest(_ request: CatalogRequest) async -> UIImage? {
        let result: Result<CatalogImage, APIError> = await networkManager.perform(request)
        switch result {
        case .success(let imageModel):
            return imageModel.base64.base64Image
        case .failure:
            logger.log(level: .error, message: "Can't download image by URL: \"\(request.urlAbsolute?.description ?? "")\"", file: #file)
            return nil
        }
    }
}







