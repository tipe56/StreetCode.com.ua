//
//  ScannerViewTest.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

// swiftlint:disable trailing_whitespace
import SwiftUI

struct ScannerView: View {
    
    @StateObject private var viewModel = ScannerViewModel()
    
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
            
            // Temporary
            Text(viewModel.qrStringItem)
                .multilineTextAlignment(.center)
            
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scaning will start automatically")
                .font(.callout)
                .foregroundStyle(.gray)
            
            Spacer(minLength: 0)
            
            // Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    ScanCameraView(frameSize: 
                                    CGSize(width: size.width, height: size.width),
                                  scannerDelegate: viewModel,
                                  captureSession: $viewModel.captureSession)

                        .scaleEffect(0.97)
                    
                    // Trimming to get scanner like edges
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
                // Square shape
                .frame(width: size.width, height: size.width)
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color.red500)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8),
                                radius: 8,
                                x: 0,
                                y: viewModel.isScanning ? 15 : -15)
                        .offset(y: viewModel.isScanning ? size.width : 0)
                })
                // To make it center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {

            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
            }
            Spacer(minLength: 45)
            
        }
        .padding(15)
    }
}

#Preview {
    ScannerView()
}


// swiftlint:enable trailing_whitespace
