//
//  RadiusButtonStyle.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.11.23.
//
import Foundation
import SwiftUI

struct RadiusButtonStyle: ViewModifier {

    var isActive: Bool

    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.white.opacity(isActive ? 1 : 0.7))
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isActive ? Color.black : .gray600.opacity(0.5))
            }
    }
}

extension View {
    func radiusButtonStyle(isActive: Bool) -> some View {
        self.modifier(RadiusButtonStyle(isActive: isActive))
    }
}
