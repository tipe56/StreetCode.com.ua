//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

@main
struct StreetcodeComUaApp: App {
    
    private let viewModel =  ViewModelStreetcodeComUaApp()
    
    init() {
        viewModel.registerServices()
    }
    
    var body: some Scene {
        WindowGroup {
            CatalogView(viewModel: CatalogVM(container: viewModel.container))      
        }
    }
}

