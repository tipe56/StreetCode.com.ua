//
//  Errors.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

import Foundation

enum CameraError: Error {
    case invalidDeviceInput
    case invalidDeviceOutput
    case invalidScannedValue
    case invalidQR
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidServerResponse
    case decodingError(Error)
}
