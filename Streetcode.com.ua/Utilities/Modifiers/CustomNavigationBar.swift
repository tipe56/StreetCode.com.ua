//
//  NavAppearanceModifier.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 3.01.24.
//

import SwiftUI

struct CustomNavigationBar: ViewModifier {
    
    init(largeTitleTextFont: UIFont,
         largeTitleTextColor: UIColor,
         titleTextFont: UIFont,
         titleTextColor: UIColor,
         backgroundColor: UIColor,
         hideSeparator: Bool) {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [.font: largeTitleTextFont, .foregroundColor: largeTitleTextColor]
        navBarAppearance.titleTextAttributes = [.font: titleTextFont, .foregroundColor: titleTextColor]
        navBarAppearance.backgroundColor = backgroundColor
        if hideSeparator { navBarAppearance.shadowColor = .clear }
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func body(content: Content) -> Content {
        content
    }
}

extension View {
    func customNavigationBarModifier(largeTitleTextFont: UIFont = .closer(.medium, size: 40),
                                     largeTitleTextColor: UIColor = .gray700,
                                     titleTextFont: UIFont = .closer(.medium, size: 20),
                                     titleTextColor: UIColor = .red500,
                                     backgroundColor: UIColor = .systemBackground,
                                     hideSeparator: Bool = false) -> some View {
        self.modifier(CustomNavigationBar(largeTitleTextFont: largeTitleTextFont,
                                          largeTitleTextColor: largeTitleTextColor,
                                          titleTextFont: titleTextFont,
                                          titleTextColor: titleTextColor,
                                          backgroundColor: backgroundColor,
                                          hideSeparator: hideSeparator))
    }
}
