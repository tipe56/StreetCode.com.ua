//
//  ImageDecoder.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI

protocol ImageLoaderable {
    func loadImage(imageId: Int) async -> Image?
}

final class ImageLoader: ImageLoaderable, ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    private let networkManager: WebAPIManagerProtocol
    let imageDecoder: ImageDecoderProtocol
    
    init(networkManager: WebAPIManagerProtocol, imageDecoder: ImageDecoderProtocol) {
        self.networkManager = networkManager
        self.imageDecoder = imageDecoder
    }
    
    func loadImage(imageId: Int) async -> Image? {
        let request = CatalogRequest.getCatalogImage(id: imageId)
        
        if let urlString = request.urlAbsolute?.absoluteString {
            let cacheKey = NSString(string: urlString)
            
            if let cacheImage = cache.object(forKey: cacheKey) {
                return Image(uiImage: cacheImage)
            }
            
            let result: Result<CatalogImageModel, APIError> = await networkManager.perform(request)
            switch result {
            case .success(let imageModel):
                do {
                    let decoded = try imageDecoder.decode(base64string: imageModel.base64)
                    if let decoded {
                        self.cache.setObject(decoded, forKey: cacheKey)
                        return Image(uiImage: decoded)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure:
                print("failure")
            }
        }
        return nil
    }
}

protocol ImageDecoderProtocol {
    func decode(base64string: String) throws -> UIImage?
}

class ImageDecoder: ImageDecoderProtocol {
    func decode(base64string: String) -> UIImage? {
        var uiImage: UIImage?
        
        if let data = Data(base64Encoded: base64string) {
            guard let decodedImage = UIImage(data: data) else { return nil }
            uiImage = decodedImage
        }
        return uiImage
    }
}




