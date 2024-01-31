//
//  Fonts+Constants.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 25.11.23.
//

import Foundation
import SwiftUI

enum CloserFont: String {
    case medium = "CloserText-Medium"
    case bold = "CloserText-Bold"
    case semibold = "CloserText-SemiBold"
    case italic = "CloserText-Italic"
}

extension Font {
    static func closer(_ font: CloserFont, size: CGFloat) -> Font {
        return .custom(font.rawValue, size: size)
    }
}

extension UIFont {
    static func closer(_ font: CloserFont, size: CGFloat) -> UIFont {
        if let closerFont = UIFont(name: font.rawValue, size: size) {
            return closerFont
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
