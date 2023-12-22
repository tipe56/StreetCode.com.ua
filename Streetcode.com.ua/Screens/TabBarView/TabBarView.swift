//
//  TabBarView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 6.12.23.
//

import SwiftUI

enum Tab: String, CaseIterable, Identifiable, Hashable {
    case personGridView
    case scannerView
    case mapView
    
    var id: Self { self }
}

struct TabBarView: View {
    
    @State var selectedTab: Tab = .personGridView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PersonGridView()
                .tabItem { Label("Catalog", systemImage: "list.bullet") }
                .tag(Tab.personGridView)
                .id("Tab.personGridView")
            
            ScannerView()
                .tabItem { Label("Scanner", systemImage: "qrcode.viewfinder") }
                .tag(Tab.scannerView)
                .id("Tab.scannerView")
            
            PersonGridView()
                .tabItem { Label("Map", systemImage: "map") }
                .tag(Tab.mapView)
                .id("Tab.mapView")
            
        }.tint(Color.red500)
            .onAppear {
                Task {
                    await setupStartTab()
                }
            }
    }
    
    func setupStartTab() async {
        let cameraAccessService = CameraAccessService()
        let savedCameraAccessStatus = cameraAccessService.readLastPermissionState()
        let currentCameraAccessStatus = await cameraAccessService.checkCameraAccess()
        
        await MainActor.run {
            if savedCameraAccessStatus != currentCameraAccessStatus {
                selectedTab = .scannerView
            } else {
                selectedTab = .personGridView
            }
        }
    }
    
//    let savedCameraAccessStatus = UserDefaults.standard.bool(forKey: "isAccessGranted")
    
    //        ScannerViewModel.checkCameraAccess { currentCameraAccessStatus in
    //            if savedCameraAccessStatus != currentCameraAccessStatus {
    //                selectedTab = .scannerView
    //            } else {
    //                selectedTab = .personGridView
    //            }
    //        }
}

#Preview {
    TabBarView()
}
