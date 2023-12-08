//
//  SwiftUIView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 7.12.23.
//

// swiftlint:disable trailing_whitespace

import SwiftUI
import AVFoundation

protocol ScannerVCDelegate: AnyObject {
    func didFind(qr: String)
    func didSurfaceError(error: CameraError)
}


final class ScannerViewModel: ObservableObject, ScannerVCDelegate  {
    func didFind(qr: String) {
        qrStringItem = qr
        if !qrStringItem.isEmpty {
            captureSession.stopRunning()
        }
    }
    
    func didSurfaceError(error: CameraError) {
        //
    }
    

    
//TODO: Make realization of torch.
//    @Published var torchIsOn: Bool = false
    
    @Published var isScanning: Bool = false
    @Published var alertItem: AlertItem?
    @Published var qrStringItem: String = ""
    @Published var captureSession = AVCaptureSession()
    
}




// swiftlint:enable trailing_whitespace
