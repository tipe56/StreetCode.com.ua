//
//  RadiusButtonStyle.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.11.23.
//
import SwiftUI

struct RadiusButtonStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 280, height: 50)
            .foregroundStyle(Color.white)
            .font(.title2)
            .fontWeight(.semibold)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red300)
            }
    }
}

extension View {
    func radiusButtonStyle() -> some View {
        self.modifier(RadiusButtonStyle())
    }
}
