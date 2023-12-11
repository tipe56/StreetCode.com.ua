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
    func didFind(qrStringValue: String)
    func didSurfaceError(error: CameraError)
}

final class ScannerViewModel: NSObject, ObservableObject, ScannerVCDelegate  {
    
    //TODO: Make realization of torch.
    //    @Published var torchIsOn: Bool = false
    
    // MARK: Properties
    @Published var captureSession = AVCaptureSession()
    @Published var isScanning: Bool = false
    @Published var alertItem: AlertItem?
    // Temporary output
    @Published var qrStringItem: String = ""
    
    var animation: Animation {
        if isScanning {
            withAnimation {
                .easeInOut(duration: 0.85)
                .delay(0.1)
                .repeatForever(autoreverses: true)
            }
        } else {
            withAnimation {
                .easeInOut(duration: 0.85)
            }
        }
    }
    
    // MARK: Functions
    
    func didFind(qrStringValue: String) {
        qrStringItem = qrStringValue
        isScanning = false
        captureSession.stopRunning()
        
    }
    
    func didSurfaceError(error: CameraError) {
        //
    }
    
    func reActivateCamera() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    
    func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            //            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            //            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        captureSession.beginConfiguration()
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            //            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutPut = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutPut) {
            captureSession.addOutput(metaDataOutPut)
            metaDataOutPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutPut.metadataObjectTypes = [.qr]
        } else {
            //
            return
        }
        captureSession.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
        isScanning = true
        //            activateScannerAnimation()
    }
    
}

extension ScannerViewModel: AVCaptureMetadataOutputObjectsDelegate  {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            print("No value")
            //            printscannerDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else { return }
        guard let qrStringValue = machineReadableObject.stringValue else {
            //            scannerDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        //      вставить проверку qr на ссылку streetcode
        //      Тут можно застопить сессию.
        
        didFind(qrStringValue: qrStringValue)
    }
}




// swiftlint:enable trailing_whitespace
