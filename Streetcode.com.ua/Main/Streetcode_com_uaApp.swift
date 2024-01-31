//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

@main
struct StreetcodeComUaApp: App {
    
    private let assembly =  AssemblyServices()
    
    init() {
        assembly.registerServices()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView(container: assembly.container)
        }
    }
}

