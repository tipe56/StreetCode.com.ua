//
//  Fonts+Constants.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 25.11.23.
//

import Foundation
import SwiftUI

extension Font {
    
    enum CloserFont {
        case medium
        case bold
        case semibold
        case italic
        case custom(String)
        
        var value: String {
            switch self {
            case .medium:
                return "CloserText-Medium"
            case .bold:
                return "CloserText-Bold"
            case .semibold:
                return "CloserText-SemiBold"
            case .italic:
                return "CloserText-Italic"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func closer(_ type: CloserFont, size: CGFloat) -> Font {
            return .custom(type.value, size: size)
        }
}
