//
//  AppDelegate.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 9.01.24.
//

import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
//    @State private(set) var container: DIContainerable = DIContainer()
    public let container: DIContainerable = DIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerServices()
        return true
    }
    
    func registerServices() {
        let networkmanager: WebAPIManagerProtocol = WebAPIManager()
        let imageDecoder: ImageDecoderable = ImageDecoder()
        
        container.register(type: WebAPIManagerProtocol.self,
                           instance: networkmanager)
        container.register(type: ImageLoadableType.self,
                           instance: ImageLoaderManager(networkManager: networkmanager,
                                                        imageDecoder: imageDecoder))
    }
}



