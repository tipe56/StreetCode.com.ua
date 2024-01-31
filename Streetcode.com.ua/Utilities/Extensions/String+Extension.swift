//
//  String+Extension.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 11.01.24.
//

import UIKit

extension String {
    var base64Image: UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return UIImage(data: data)
    }
}
