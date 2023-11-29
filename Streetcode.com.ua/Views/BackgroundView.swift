//
//  BackgroundView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.11.23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Image("gridBackground")
                .resizable(resizingMode: .tile)
                .frame(alignment: .top)
            Rectangle()
                .fill(LinearGradient(
                    colors: [.clear, .white, .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            
        }.ignoresSafeArea(edges: .top)
    }
}

#Preview {
    BackgroundView()
}
