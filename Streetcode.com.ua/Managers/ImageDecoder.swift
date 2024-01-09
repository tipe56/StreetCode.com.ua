//
//  ImageDecoder.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 9.01.24.
//

import UIKit

protocol ImageDecoderable {
    func decode(base64string: String) throws -> UIImage?
}

class ImageDecoder: ImageDecoderable {
    func decode(base64string: String) -> UIImage? {
        var uiImage: UIImage?
        
        if let data = Data(base64Encoded: base64string) {
            guard let decodedImage = UIImage(data: data) else { return nil }
            uiImage = decodedImage
        }
        return uiImage
    }
}
