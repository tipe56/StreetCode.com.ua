//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

@main
struct StreetcodeComUaApp: App {
    private let networkManager = WebAPIManager()
    private let imageDecoder = ImageDecoder()

    var body: some Scene {
        WindowGroup {
            CatalogView(viewmodel: CatalogVM(networkManager: networkManager), networkManager: networkManager, imageDecoder: imageDecoder)
        }
    }
}
