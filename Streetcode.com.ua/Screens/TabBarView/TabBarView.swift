//
//  TabBarView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 6.12.23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            PersonGridView()
                .tabItem { Label("Catalog", systemImage: "list.bullet") }
            PersonGridView()
                .tabItem { Label("Scanner", systemImage: "qrcode.viewfinder") }
            PersonGridView()
                .tabItem { Label("Map", systemImage: "map") }
        }.tint(Color.red500)
    }
}

#Preview {
    TabBarView()
}
