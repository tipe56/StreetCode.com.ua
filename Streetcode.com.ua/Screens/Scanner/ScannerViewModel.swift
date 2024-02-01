//
//  ScannerViewModel.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 7.12.23.
//


import SwiftUI
import AVFoundation

protocol ScannerVCDelegate: AnyObject {
    func didFind(qrStringValue: String)
    func didSurfaceError(error: CameraError)
}

final class ScannerViewModel: NSObject, ObservableObject, ScannerVCDelegate  {
    
    //TODO: Add realization of torch.
    
    // MARK: Properties
    @Published var captureSession = AVCaptureSession()
    @Published var isScanning: Bool = false
    @Published var cameraAccessApproved = false
    // Alerts & Errors
    @Published var showPermissionAlert: Bool = false
    @Published var alertItem: AlertItem?
    @Published var isShowingAlert: Bool = false
    
    // Temporary output
    @Published var qrStringItem: String = ""
    
    var animation: Animation {
        if isScanning {
            Animation
                .easeInOut(duration: 0.85)
                .delay(0.1)
                .repeatForever(autoreverses: true)
        } else {
            Animation
                .easeInOut(duration: 0.85)
        }
    }
    
    // MARK: Functions
    func didFind(qrStringValue: String) {
        qrStringItem = qrStringValue
        deActivateScannerAnimation()
        // Main
        DispatchQueue.main.async {
            self.captureSession.stopRunning()
        }
    }
    
    func didSurfaceError(error: CameraError) {
        isShowingAlert = true
        deActivateScannerAnimation()
        
        switch error {
        case .invalidDeviceInput:
            alertItem = AlertContext.invalidDeviceInput
        case .invalidDeviceOutput:
            alertItem = AlertContext.invalidDeviceOutput
        case .invalidScannedValue:
            alertItem = AlertContext.invalidScannedValue
        case .invalidQR:
            alertItem = AlertContext.invalidQR
        }
    }
    
    func reActivateCamera() {
//        DispatchQueue.global(qos: .background).async {
//            self.captureSession.startRunning()
//        }
        // Main
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
        activateScannerAnimation()
    }
    
    func activateScannerAnimation() {
        isScanning = true
    }
    
    func deActivateScannerAnimation() {
        isScanning = false
    }
    
    func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        captureSession.beginConfiguration()
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            didSurfaceError(error: .invalidDeviceInput)
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
        activateScannerAnimation()
        
//        DispatchQueue.global(qos: .background).async {
//            self.captureSession.startRunning()
//        }
        // Main
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    func provideCameraAccess() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else  {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func checkCameraPermission() {
        Task {
            switch await AVCaptureDevice.requestAccess(for: .video) {
                
            case true:
                if captureSession.inputs.isEmpty {
                    // New setup
                    setupCaptureSession()
                } else {
                    // Use existing
                    reActivateCamera()
                }
            case false:
                cameraAccessApproved = false
                showPermissionAlert.toggle()
            }
        }
// Using handler. Not sure about retain cycle
//        AVCaptureDevice.requestAccess(for: .video) { [weak self] access in
//            guard let self else {
//                return
//            }
//            
//            switch access {
//                
//            case true:
//                cameraAccessApproved = true
//                
//                if captureSession.inputs.isEmpty {
//                    // New setup
//                    setupCaptureSession()
//                } else {
//                    // Use existing
//                    reActivateCamera()
//                }
//            case false:
//                cameraAccessApproved = false
//                showPermissionAlert.toggle()
//            }
//        }
            
// OLD implementation,
        //        Task {
        //            switch AVCaptureDevice.authorizationStatus(for: .video) {
        //
        //            case .notDetermined:
        //                // requesting camera access
        //
        //                if await AVCaptureDevice.requestAccess(for: .video) {
        //                    /// Permission Granded
        ////                    cameraPermission = .approved
        //                    setupCaptureSession()
        //                } else {
        //                    /// Permission Denied
        ////                    cameraPermission = .denied
        ////                    presentError("Please provide access to camera for scanning codes")
        //                    print("Please provide access to camera for scanning codes")
        //                }
        //            case .denied, .restricted:
        ////                cameraPermission = .denied
        //                self.showPermissionAlert.toggle()
        //
        //                if await AVCaptureDevice.requestAccess(for: .video) {
        //                    /// Permission Granded
        ////                    cameraPermission = .approved
        //
        //                    setupCaptureSession()
        //
        //
        //                } else {
        //                    /// Permission Denied
        ////                    cameraPermission = .denied
        ////                    presentError("Please provide access to camera for scanning codes")
        //                    print("denied")
        //                }
        //            case .authorized:
        //                print("autorized")
        ////                cameraPermission = .approved
        //                if captureSession.inputs.isEmpty {
        //                    /// New setup
        //                    print("empty input")
        //                    setupCaptureSession()
        //                } else {
        //                    /// Use existing
        //                    print("NOT empty input")
        //                    reActivateCamera()
        //                }
        //
        //            default:
        //                break
        //            }
        //        }
    }
}

//MARK: - Extensions
extension ScannerViewModel: AVCaptureMetadataOutputObjectsDelegate  {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            didSurfaceError(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else { return }
        guard let qrStringValue = machineReadableObject.stringValue else {
            didSurfaceError(error: .invalidScannedValue)
            return
        }
        
        guard qrStringValue.contains("streetcode.com.ua") else {
            didSurfaceError(error: .invalidQR)
            return
        }
        didFind(qrStringValue: qrStringValue)
        //Note: here we can stop session
    }
}
