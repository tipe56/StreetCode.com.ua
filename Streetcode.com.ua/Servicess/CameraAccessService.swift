//
//  CameraAccessService.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 22.12.23.
//

import Foundation
import AVFoundation

class CameraAccessService {
//    func checkCameraAccess(completion: @escaping (Bool) -> Void) {
//        Task {
//            let isAccessGranted = await AVCaptureDevice.requestAccess(for: .video)
//            completion(isAccessGranted)
//        }
//    }
//    
//    func saveLastPermissionState() {
//        ScannerViewModel.checkCameraAccess { isAccessGranted in
//            UserDefaults.standard.set(isAccessGranted, forKey: "isAccessGranted")
//        }
//    }
    
    func checkCameraAccess() async -> Bool {
             await AVCaptureDevice.requestAccess(for: .video)
    }
    
    
    func saveLastPermissionState() async {
        let isAccessGranted = await checkCameraAccess()
        UserDefaults.standard.set(isAccessGranted, forKey: "isAccessGranted")
    }
    
    func readLastPermissionState() -> Bool {
        UserDefaults.standard.bool(forKey: "isAccessGranted")
    }
}
