//
//  NetworkStatusService.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.01.24.
//

import Foundation
import Network

protocol NetworkStatusServicable {
    var status: ((Bool) -> Void)? { get set }
    func start()
}

final class NetworkStatusService: NetworkStatusServicable {
    var status: ((Bool) -> Void)?
    private let queue = DispatchQueue(label: "NetworkService")
    private let monitor = NWPathMonitor()
    
    func start() {
        monitor.pathUpdateHandler = { [unowned self] property in
            if property.status == .satisfied {
                self.status?(true)
            } else {
                self.status?(false)
            }
        }
        monitor.start(queue: queue)
    }
}
