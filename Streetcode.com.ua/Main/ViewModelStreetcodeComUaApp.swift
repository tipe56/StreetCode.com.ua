//
//  ViewModelStreetcodeComUaApp.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 31.01.24.
//

import Foundation

class ViewModelStreetcodeComUaApp {
    
    let container: DIContainerable = DIContainer()
    
    func registerServices() {
        let logger: Loggering = LoggerManager()
        let networkmanager: WebAPIManagerProtocol = WebAPIManager(logger: logger)
        
        container.register(
            type: WebAPIManagerProtocol.self,
            instance: networkmanager)
        container.register(
            type: ImageLoadableType.self,
            instance: ImageLoaderManager(networkManager: networkmanager, logger: logger))
        container.register(
            type: Loggering.self,
            instance: logger)
    }
}
