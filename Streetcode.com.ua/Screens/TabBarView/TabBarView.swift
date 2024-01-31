//
//  TabBarView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 6.12.23.
//

import SwiftUI

struct TabBarView: View {
    
    let container: DIContainerable
    
    var body: some View {
        TabView {
            CatalogView(viewModel: CatalogVM(container: container))
                .tabItem { Label("Catalog", systemImage: "list.bullet") }
            ScannerView()
                .tabItem { Label("Scanner", systemImage: "qrcode.viewfinder") }
            ScannerView()
                .tabItem { Label("Map", systemImage: "map") }
        }.tint(Color.red500)
    }
}

//#Preview {
//    TabBarView()
//}
