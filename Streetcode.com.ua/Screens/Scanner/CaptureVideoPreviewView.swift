//
//  CaptureVideoPreviewView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

import SwiftUI
import AVFoundation

struct CaptureVideoPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    let frameSize: CGSize
    
    func makeUIView(context: Context) -> AVCaptureVideoPreviewView {
        let view = AVCaptureVideoPreviewView()
        if let layer = view.layer as? AVCaptureVideoPreviewLayer {
            layer.session = session
            layer.frame = CGRect(origin: .zero, size: frameSize)
            layer.backgroundColor = CGColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            layer.videoGravity = .resizeAspectFill
        }
        return view
    }
    
    func updateUIView(_ uiView: AVCaptureVideoPreviewView, context: Context) {
        //
    }  
}


