//
//  LoadingView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Image("Logo-animation_40_1x")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .all)
        }
    }
}

#Preview {
    LoadingView()
}
