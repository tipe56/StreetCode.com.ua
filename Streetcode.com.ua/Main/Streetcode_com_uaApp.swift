//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

@main
struct StreetcodeComUaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            CatalogView(viewmodel: CatalogVM(container: appDelegate.container))
//            CheckCoreData(container: appDelegate.container)
        }
    }
}

