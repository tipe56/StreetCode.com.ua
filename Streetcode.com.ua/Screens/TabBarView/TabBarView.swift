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
    private let cameraAccessService: CameraAccessServicable = CameraAccessService()

    @State var selectedTab: Tab = .personGridView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PersonGridView()
                .tabItem { Label("Catalog", systemImage: "list.bullet") }
                .tag(Tab.personGridView)
                .id("Tab.personGridView")
            
            ScannerView(cameraAccessService: cameraAccessService)
                .tabItem { Label("Scanner", systemImage: "qrcode.viewfinder") }
                .tag(Tab.scannerView)
                .id("Tab.scannerView")
            
            PersonGridView()
                .tabItem { Label("Map", systemImage: "map") }
                .tag(Tab.mapView)
                .id("Tab.mapView")
            
        }.tint(Color.red500)
        .onAppear {
          setupStartTab()
        }
    }
    
    func setupStartTab() {
      Task {
        let access = await cameraAccessService.checkAccess(for: .video)

        await MainActor.run {
          selectedTab = access ? .scannerView : .personGridView
        }
      }
    }
}

#Preview {
    TabBarView()
}
