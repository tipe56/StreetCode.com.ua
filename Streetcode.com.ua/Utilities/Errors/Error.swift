//
//  NetworkError.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.12.23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidServerResponse
    case decodingError(Error)
}
