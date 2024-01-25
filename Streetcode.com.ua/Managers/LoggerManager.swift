//
//  LoggerManager.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 12.01.24.
//

import Foundation
import OSLog

protocol Loggering {
    func log(level: OSLogType, message: String, file: String)
}

extension Loggering {
    func log(level: OSLogType = .error, message: String, file: String = #file) {
        log(level: level, message: message, file: file)
    }
}

final class LoggerManager: Loggering {
    private let logger = Logger()
    
    func log(level: OSLogType, message: String, file: String) {
        logger.log(level: level, "\(file): \(message)")
    }
}

