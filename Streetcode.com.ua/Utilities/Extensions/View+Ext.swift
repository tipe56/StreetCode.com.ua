//
//  View+Ext.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 29.11.23.
//

import SwiftUI


extension View {
    func radiusButtonStyle() -> some View {
        self.modifier(RadiusButtonStyle())
    }
}
