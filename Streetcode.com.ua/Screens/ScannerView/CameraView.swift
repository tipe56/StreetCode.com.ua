//
//  CameraView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 6.12.23.
//

// swiftlint:disable trailing_whitespace

import SwiftUI
import AVKit

///CameraView Using AVCaptureVideoPlayer
struct CameraView: UIViewRepresentable {
    var frameSize: CGSize
    
    /// Camera Session
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        
        /// Define Camera Frame Size
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        /// Define Camera layer
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = CGRect(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        
        view.layer.addSublayer(cameraLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}


// swiftlint:enable trailing_whitespace
