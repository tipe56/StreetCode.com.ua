//
//  Streetcode_com_uaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

@main
struct StreetcodeComUaApp: App {
    private let container: DIContainerable = DIContainer()

    init() {
        registerServices()
    }
    
    var body: some Scene {
        WindowGroup {
            CatalogView(viewmodel: CatalogVM(container: container))
        }
    }
    
    func registerServices() {
        let networkmanager: WebAPIManagerProtocol = WebAPIManager()
        let imageDecoder: ImageDecoderProtocol = ImageDecoder()
        
        container.register(type: WebAPIManagerProtocol.self,
                           instance: networkmanager)
        container.register(type: ImageLoaderable.self,
                           instance: ImageLoader(networkManager: networkmanager, 
                                                 imageDecoder: imageDecoder))
    }
}
