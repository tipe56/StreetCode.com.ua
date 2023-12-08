//
//  MySwiftUIView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

// swiftlint:disable trailing_whitespace

import SwiftUI
import AVFoundation

struct ScanCameraView: UIViewControllerRepresentable {
    
    let frameSize: CGSize
    let scannerDelegate: ScannerVCDelegate
    
    @Binding var captureSession: AVCaptureSession
    
    func makeUIViewController(context: Context) -> ScannerVC {
        let scannerVC = ScannerVC(frameSize: frameSize, 
                                  captureSession: captureSession,
                                  scannerDelegate: scannerDelegate)
        return scannerVC
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) { }
    
}

// swiftlint:enable trailing_whitespace

