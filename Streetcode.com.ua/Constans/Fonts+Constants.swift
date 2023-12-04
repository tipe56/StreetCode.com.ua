//
//  Fonts+Constants.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 25.11.23.
//

import Foundation
import SwiftUI

extension Font {
    
    enum CloserFont: String {
        case medium = "CloserText-Medium"
        case bold = "CloserText-Bold"
        case semibold = "CloserText-SemiBold"
        case italic = "CloserText-Italic"
    }
    
    static func closer(_ font: CloserFont, size: CGFloat) -> Font {
        return .custom(font.rawValue, size: size)
        }
}
