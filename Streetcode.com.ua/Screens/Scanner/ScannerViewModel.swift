//
//  SwiftUIView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 7.12.23.
//

// swiftlint: disable

import SwiftUI
import AVFoundation

protocol ScannerVCDelegate: AnyObject {
    func didFind(qr: String)
    func didSurfaceError(error: CameraError)
}


final class ScannerViewModel: NSObject, ObservableObject, ScannerVCDelegate  {
   
//TODO: Make realization of torch.
//    @Published var torchIsOn: Bool = false
    
    @Published var isScanning: Bool = false
    @Published var alertItem: AlertItem?
    @Published var qrStringItem: String = ""
    var captureSession = AVCaptureSession()
    
    
    func didFind(qr: String) {
        qrStringItem = qr
        if !qrStringItem.isEmpty {
            captureSession.stopRunning()
        }
    }
    
    func didSurfaceError(error: CameraError) {
        //
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
        } 
 
}

extension ScannerViewModel: AVCaptureMetadataOutputObjectsDelegate  {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
//            scannerDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else { return }
        guard let barcode = machineReadableObject.stringValue else {
//            scannerDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        // вставить проверку qr на ссылку streetcode
//        Тут можно застопить сессию.
        didFind(qr: barcode)
        print(barcode)
        captureSession.stopRunning()
        
    }
}




// swiftlint:enable
