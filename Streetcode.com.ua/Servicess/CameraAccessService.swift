//
//  CameraAccessService.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 22.12.23.
//

import Foundation
import AVFoundation

protocol CameraAccessServicable {
  func checkAccess(for mediaType: AVMediaType) async -> Bool
}

final class CameraAccessService: CameraAccessServicable {
    func checkAccess(for mediaType: AVMediaType) async -> Bool {
        await AVCaptureDevice.requestAccess(for: mediaType)
    }
}
