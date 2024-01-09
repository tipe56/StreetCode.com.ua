//
//  ImageDecoder.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI

protocol ImageLoadableType {
    func loadImage(imageId: Int) async -> Image?
    var isFailLoading: Bool { get }
}

final class ImageLoaderManager: ImageLoadableType, ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    private let networkManager: WebAPIManagerProtocol
    let imageDecoder: ImageDecoderable
    @Published var isFailLoading: Bool = false
    
    init(networkManager: WebAPIManagerProtocol, imageDecoder: ImageDecoderable) {
        self.networkManager = networkManager
        self.imageDecoder = imageDecoder
    }
    
    func loadImage(imageId: Int) async -> Image? {
        isFailLoading = false
        let request = CatalogRequest.getCatalogImage(id: imageId)
        var cacheKey = NSString()
        
        if let urlString = request.urlAbsolute?.absoluteString {
            cacheKey = NSString(string: urlString)
        }
        
        guard let cacheImage = self.cache.object(forKey: cacheKey) else {
            if let image = await networkImageRequest(request: request) {
                self.cache.setObject(image, forKey: cacheKey)
                return Image(uiImage: image)
            } else {
                isFailLoading = true
                return nil
            }
        }
        return Image(uiImage: cacheImage)
    }
    
    func networkImageRequest(request: CatalogRequest) async -> UIImage? {
        let result: Result<CatalogImage, APIError> = await networkManager.perform(request)
        var image: UIImage?
        
        switch result {
        case .success(let imageModel):
            do {
                let decoded = try imageDecoder.decode(base64string: imageModel.base64)
                if let decoded {
                    image = decoded
                }
            } catch {
                isFailLoading = true
                print("ImageLoaderManager: Can't decode image with URL: \"\(String(describing: request.urlAbsolute))\"")
            }
        case .failure:
            isFailLoading = true
            print("ImageLoaderManager: Can't download image by URL: \"\(String(describing: request.urlAbsolute))\"")
        }
        return image
    }
}







