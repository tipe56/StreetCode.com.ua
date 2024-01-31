//
//  LoggerManager.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 12.01.24.
//

import Foundation
import OSLog

protocol Loggering {
    func info(_ message: String)
    func warning(_ message: String)
    func error(_ message: String)
    func debug(_ message: String)
}

class LoggerManager: Loggering {
    let logger = Logger()
    
    func info(_ message: String) {
        logger.info("File: \(String(describing: type(of: self))), \(message)")
    }
    
    func warning(_ message: String) {
        logger.warning("File: \(String(describing: type(of: self))), \(message)")
    }
    
    func error(_ message: String) {
        logger.error("File: \(String(describing: type(of: self))), Error: \(message)")
    }
    
    func debug(_ message: String) {
        logger.debug("File: \(String(describing: type(of: self))), \(message)")
    }
}

