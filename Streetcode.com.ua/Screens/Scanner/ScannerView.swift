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
        VStack(spacing: 8) {
            
            // Temporary output
            Text(viewModel.qrStringItem)
                .multilineTextAlignment(.center)
            
            Text("Place the QR code inside the area")
                .font(.title3)
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
                viewModel.reActivateCamera()
                viewModel.qrStringItem = ""
                viewModel.isScanning = true
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
            }
            Spacer(minLength: 45)
            
        }
        .padding(15)
        .onAppear {
            viewModel.setupCaptureSession()
        }
        .onDisappear {
            viewModel.captureSession.stopRunning()
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(viewModel.animation, value: viewModel.isScanning)
            }
        }
    }
}

#Preview {
    ScannerView()
}

// swiftlint:enable trailing_whitespace
