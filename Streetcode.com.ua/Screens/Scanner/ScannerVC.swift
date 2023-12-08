//
//  ScannerVCTest.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

// swiftlint:disable trailing_whitespace

import AVFoundation
import SwiftUI



final class ScannerVC: UIViewController {
    
    let frameSize: CGSize
    var captureSession: AVCaptureSession
    var previewLayer: AVCaptureVideoPreviewLayer?
    var scannerDelegate: ScannerVCDelegate?
    
    init(frameSize: CGSize, captureSession: AVCaptureSession, scannerDelegate: ScannerVCDelegate) {
        self.captureSession = captureSession
        self.frameSize = frameSize
        self.scannerDelegate = scannerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    private func setupCaptureSession() {
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let previewLayer {
            previewLayer.frame = CGRect(origin: .zero, size: frameSize)
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    } 
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate  {
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
        scannerDelegate?.didFind(qr: barcode)
        print(barcode)
        //captureSession.stopRunning()
        
    }
}

// swiftlint:enable trailing_whitespace
