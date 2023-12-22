//
//  ScannerViewTest.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

// swiftlint:disable trailing_whitespace
import SwiftUI

struct ScannerView: View {
    
    // MARK: Properties
    @StateObject private var viewModel = ScannerViewModel()
    
    // MARK: Body
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 8) {
                
                // Temporary output
                Text(viewModel.qrStringItem)
                    .multilineTextAlignment(.center)
                
                Text("Place the QR code inside the area")
                    .font(.closer(.medium, size: 22))
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.top, 20)
                
                Text("Scaning will start automatically")
                    .font(.callout)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Scanner(viewModel: viewModel)
                    .padding(.horizontal, 45)
                
                Spacer(minLength: 15)
                
                Button {
                    Task {
                        await viewModel.checkCameraPermission()
                    }
                    // Temporary output
                    viewModel.qrStringItem = ""
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundStyle(.red500)
                }
                Spacer(minLength: 45)
            }
            .padding(15)
        }
        .onAppear {
            Task {
                await viewModel.checkCameraPermission()
            }
        }
        .onChange(of: viewModel.cameraAccessApproved, perform: { access in
            if access {
                viewModel.activateScannerAnimation()
            }
        })
        .onDisappear {
            viewModel.captureSession.stopRunning()
        }
        .alert("Please provide the camera access to scan the QR", isPresented: $viewModel.showPermissionAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Settings", role: .none) {
                DispatchQueue.main.async {
                    viewModel.provideCameraAccess()
                }
            }
        }
        .alert(viewModel.alertItem?.title ?? "", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { viewModel.activateScannerAnimation() }
        } message: {
            viewModel.alertItem?.message
        }
        
    }
    
    // MARK: ViewBuilders & SubViews
    
    struct Scanner: View {
        
        @ObservedObject var viewModel: ScannerViewModel
        
        var body: some View {
            GeometryReader {
                let size = $0.size
                ZStack {
                    CaptureVideoPreviewView(session: viewModel.captureSession,
                                            frameSize: CGSize(width: size.width, height: size.width))
                    .scaleEffect(0.97)
                    
                    // Сamera Corners
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
                .frame(width: size.width, height: size.width)
                
                // camera Strip Animation
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.red500)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8),
                                radius: 8,
                                x: 0,
                                y: viewModel.isScanning ? 15 : -15)
                        .offset(y: viewModel.isScanning ? size.width : 0)
                }
                .animation(viewModel.animation, value: viewModel.isScanning)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
    }
}

#Preview {
    ScannerView()
}

// swiftlint:enable trailing_whitespace
