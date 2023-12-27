//
//  NetworkManager.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

// swiftlint:disable all

import UIKit

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidServerResponse
    case decodingError(Error)
}

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
//    func parseJSON<T: Decodable>(data: Data) throws -> T
}

extension DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T {
        try parseJSON(data: data)
    }
    
    func parseJSON<T: Decodable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}

class DefaultDataParser: DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

protocol WebAPIManagerProtocol {
//    func perform(_ request: RequestProtocol) async throws -> Data
    func perform<T: Decodable>(_ request: RequestProtocol, parser: DataParserProtocol) async throws -> T
    func performResult<T: Decodable>(_ request: RequestProtocol, parser: DataParserProtocol) async -> Result<T, APIError>
}


public class WebAPIManager: WebAPIManagerProtocol {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
//    private func perform(_ request: RequestProtocol) async throws -> Data {
//        let (data, response) = try await urlSession.data(for: request.makeURLRequest())
//        
//        guard let httpResponse = response as? HTTPURLResponse,
//            (200..<300).contains(httpResponse.statusCode)
//        else {
//            throw NetworkError.invalidServerResponse
//        }
//        return data
//    }
    
    func perform<T: Decodable>(_ request: RequestProtocol, parser: DataParserProtocol = DefaultDataParser()) async throws -> T {
        let data = try await perform(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    func performResult<T: Decodable>(_ request: RequestProtocol, parser: DataParserProtocol = DefaultDataParser()) async -> Result<T, APIError> {
        do {
            let data = try await perform(request)
            let decoded: T = try parser.parse(data: data)
            return .success(decoded)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error))
        }
    }

    private func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: try request.makeURLRequest())
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidServerResponse
        }
        return data
    }
 
}

