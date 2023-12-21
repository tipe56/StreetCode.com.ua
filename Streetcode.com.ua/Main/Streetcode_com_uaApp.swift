//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI
import AVFoundation

@main
struct StreetcodeComUaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .background {
                        ScannerViewModel.saveLastPermissionState()
                    }
                }
        }
    }
}
