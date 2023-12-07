//
//  ScannerView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 6.12.23.
//

// swiftlint:disable trailing_whitespace

import SwiftUI
import AVKit

struct ScannerView: View {
    
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    /// qr Scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    /// Error Properties
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @Environment(\.openURL) private var openURL
    /// Camera qr output Delegate
    @StateObject private var qrDelegate = QRScannerDelegate()
    /// Scanned Code
    @State private var scannedCode: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                //
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundStyle(Color.red500)
            }
            .frame(maxWidth: .infinity,
                    alignment: .leading)
            
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scaning will start automatically")
                .font(.callout)
                .foregroundStyle(.gray)
            
            Spacer(minLength: 0)
            
            /// Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                        .scaleEffect(0.97)
                    /// Trimming to get scanner like edges
                    ForEach(0..<4, id: \.self) { index in
                        let rotation: Double = Double(index) * 90
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.red500, style: StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round,
                                lineJoin: .round))
                            .rotationEffect(Angle(degrees: rotation))
                    }
                }
                /// Square shape
                .frame(width: size.width, height: size.width)
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color.red500)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8),
                                radius: 8,
                                x: 0,
                                y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                /// To make it center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reActivateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
            }
            Spacer(minLength: 45)

        }
        .padding(15)
        /// Checking Camera Permission, when the View is visible
        .onAppear {
            checkCameraPermission()
        }
        .onDisappear {
            session.stopRunning()
        }
        .onChange(of: qrDelegate.scannedCode) { newValue in
            if let code = newValue {
                scannedCode = code
                /// When first code is avaliable, immediaetelly stop camera
                session.stopRunning()
                /// Stop camera animation
                deActivateScannerAnimation()
                /// Cleaning the data on delegate
                qrDelegate.scannedCode = nil
            }
        }
        .alert(errorMessage, isPresented: $showError) {
            /// Showing setting's button, if permission is denied
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingURL = URL(string: settingsString) {
                        // Opening App's setting using openURL SwiftUI API
                        openURL(settingURL)
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    
    func reActivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    /// Activating Camera Scanner Animation method
    func activateScannerAnimation() {
        withAnimation(
            .easeInOut(duration: 0.85)
            .delay(0.1)
            .repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    /// Deactivating Camera Scanner Animation method
    func deActivateScannerAnimation() {
        withAnimation(
            .easeInOut(duration: 0.85)) {
                isScanning = false
            }
    }
    
    /// Checking Camera Permissions
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                /// requesting camera access
                if await AVCaptureDevice.requestAccess(for: .video) {
                    /// Permission Granded
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    /// Permission Denied
                    cameraPermission = .denied
                    presentError("Please provide access to camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    /// New setup
                    setupCamera()
                } else {
                    /// Use existing
                    reActivateCamera()
                }
                
            default:
                break
            }
        }
    }
    
    func setupCamera() {
        do {
           /// Finding back camera
            guard let device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera],
                mediaType: .video,
                position: .back)
                .devices.first else {
                    presentError("UNKNOWN DEVICE ERROR")
                    return
                }
            /// Camera input
            let input = try AVCaptureDeviceInput(device: device)
            
            /// Checking input and output can be added to section
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else { 
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            /// Adding input and output to camera session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            /// Setting output config to read QR codes
            qrOutput.metadataObjectTypes = [.qr, .microQR]
            
            /// Adding Delegate to retrive the fetching QR code from camera
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            /// Note session must be started on background thread
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
    
}

#Preview {
    ScannerView()
}

// swiftlint:enable trailing_whitespace
