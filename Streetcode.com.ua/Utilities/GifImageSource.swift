//
//  GifImageSource.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 18.01.24.
//

import SwiftUI

struct GifImageSource {
    
    public func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("GifImageSource: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("GifImageSource: Cannot turn image named \"\(name)\" into Data")
            return nil
        }
        guard let image = animatedImage(withGIFData: imageData) else { return nil}
        return image
    }
    
    private func animatedImage(withGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("GifImageSource: Cannot casting Data to CFData")
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(source)
        var frames: [UIImage] = []
        var gifDuration = 0.0
        
        for i in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil),
               let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
               let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) {
                gifDuration += frameDuration.doubleValue
            }
            
            let frameImage = UIImage(cgImage: cgImage)
            frames.append(frameImage)
        }
        
        let animatedImage = UIImage.animatedImage(with: frames, duration: gifDuration)
        return animatedImage
    }
}
