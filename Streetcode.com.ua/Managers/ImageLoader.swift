//
//  ImageDecoder.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI


final class ImageLoader: ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    let networkManager: WebAPIManagerProtocol
    let imageDecoder: ImageDecoderProtocol
    @Published var image: Image? = nil
    
    
    init(networkManager: WebAPIManagerProtocol, imageDecoder: ImageDecoderProtocol) {
        self.networkManager = networkManager
        self.imageDecoder = imageDecoder
    }
    
    @MainActor
    func loadImage(imageId: Int) async {
        let request = CatalogRequest.getCatalogImage(id: imageId)
        
        if let urlString = request.urlAbsolute?.absoluteString {
            
            let cacheKey = NSString(string: urlString)
            
            if let cacheImage = cache.object(forKey: cacheKey) {
                self.image = Image(uiImage: cacheImage)
                return
            }
            
            do {
                let imageModel: CatalogImageModel = try await networkManager.perform(request, parser: DefaultDataParser())
                let decoded = try imageDecoder.decode(base64string: imageModel.base64)
                if let decoded {
                    image = Image(uiImage: decoded)
                    self.cache.setObject(decoded, forKey: cacheKey)
                }
            } catch {
                if let apError = error as? APIError {
                    switch apError {
                    case .invalidURL:
                        print(".invalidURL")
                    case .networkError(let error):
                        print(".networkError")
                    case .invalidServerResponse:
                        print(".invalidServerResponse")
                    case .decodingError(let error):
                        print(".decodingError")
                    }
                } else {
                    print("invalid response")
                }
                
            }
        }
    }
}

struct RemoteImage: View {
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("catalog-placeholder").resizable()
    }
}


struct CatalogRemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader
    let imageId: Int
    
    var body: some View {
        RemoteImage(image: imageLoader.image )
            .onAppear {
                Task {
                    await imageLoader.loadImage(imageId: imageId)
                }
            }
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




