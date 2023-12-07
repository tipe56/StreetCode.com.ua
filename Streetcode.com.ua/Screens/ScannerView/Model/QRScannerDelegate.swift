//
//  QRScannerDelegate.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 6.12.23.
//

import SwiftUI
import AVKit

final class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            print(code)
            scannedCode = code
        }
    }
}
