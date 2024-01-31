//
//  DIContainer.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import Foundation

protocol DIContainerable {
    func register<T>(type: T, instance: Any)
    func resolve<T>() -> T?
}

final class DIContainer: DIContainerable {
    private var services: [String: Any] = [:]
    
    func register<T>(type: T, instance: Any) {
        services["\(T.self)"] = instance
    }
    
    func resolve<T>() -> T? {
        services["\(type(of: T.self))"] as? T
    }
}
