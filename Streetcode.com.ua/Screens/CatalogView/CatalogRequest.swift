//
//  CatalogRequest.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.12.23.
//

import Foundation


enum CatalogRequest {
    private struct Constants {
        static let baseURL = "backend.streetcode.com.ua"
    }
    
    case getCount
    case getCatalog(page: Int, count: Int)
    case getCatalogImage(id: Int)
}

extension CatalogRequest: RequestProtocol {
    var host: String {
        switch self {
        case .getCount, .getCatalog, .getCatalogImage:
            Constants.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getCount:
            "/api/streetcode/getCount"
        case .getCatalog:
            "/api/streetcode/getAllCatalog"
        case .getCatalogImage(id: let id):
            "/api/image/getById/\(id)"
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getCount, .getCatalog, .getCatalogImage:
            [:]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getCount, .getCatalog, .getCatalogImage:
            [:]
        }
    }
    
    var urlParameters: [String : String?] {
        switch self {
        case .getCount:
            [:]
        case .getCatalog(let page, let count):
            ["page" : "\(page)",
             "count" : "\(count)"]
        case .getCatalogImage:
            [:]
//            ["": "\(id)"]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .getCount, .getCatalog, .getCatalogImage:
            .GET
        }
    }  
}