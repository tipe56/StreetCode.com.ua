//
//  Alerts.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 8.12.23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: Text("Invalid Device Input"),
                                              message: Text("Something is wrong with the camera. We are unable to capture the input."),
                                              dismissButton: .default(Text("OK")))
    
    static let invalidScannedValue = AlertItem(title: Text("Invalid Scan Type"),
                                              message: Text("The value scanned is not valid. This App scans only QR-codes."),
                                              dismissButton: .default(Text("OK")))
}
