//
//  Alerts.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

import SwiftUI

//struct AlertItem: Identifiable {
//    let id = UUID()
//    let title: Text
//    let message: Text
//    let dismissButton: Alert.Button
//}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: Text?
}


struct AlertContext {
//MARK: - Scanner Alert
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: Text("Something is wrong with the camera. We are unable to capture the input. Try to restart Application"))
    static let invalidDeviceOutput = AlertItem(title: "Invalid Device Output",
                                              message: Text("Something goes wrong with the camera. We are unable to set the output. Try to restart Application"))
    static let invalidScannedValue = AlertItem(title: "Invalid Scan Type",
                                               message: Text("The value scanned is not valid. This App scans only QR codes."))
    static let invalidQR = AlertItem(title: "This is not Streetcode.com.ua QR-code",
                                     message: Text("This Application able to scan only Streetcode.com.ua QR codes"))
}


