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


#Preview {
    LoadingView(gifBundleName: "Logo-animation_40", width: 420, height: 420)
}
