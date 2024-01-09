//
//  LoadingView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI

struct LoadingView: View {
    let gifBundleName: String
    let width: Int
    let height: Int
    
    var body: some View {
        GifImageRepresentable(gifBundleName: gifBundleName, width: width, height: height)
    }
}

struct GifImageRepresentable: UIViewRepresentable {
    let gifBundleName: String
    let width: Int
    let height: Int
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let source = GifImageSource()
        let image = source.gifImageWithName(gifBundleName)
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let imageViewSize = CGSize(width: width, height: height)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageViewSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageViewSize.height),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

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

#Preview {
    LoadingView(gifBundleName: "Logo-animation_40", width: 420, height: 420)
}

