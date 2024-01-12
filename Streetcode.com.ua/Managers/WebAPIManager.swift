//
//  NetworkManager.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import UIKit

protocol DataParserType {
    func parse<T: Decodable>(data: Data) throws -> T
}

extension DataParserType {
    func parse<T: Decodable>(data: Data) throws -> T {
        try parseJSON(data: data)
    }
    
    func parseJSON<T: Decodable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}

class DefaultDataParser: DataParserType {
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
    func perform<T: DataDecodable>(_ request: RequestProtocol) async -> Result<T, APIError>
    func perform<T: DataDecodable>(_ request: RequestProtocol) async -> Result<Array<T>, APIError>
}

protocol DataDecodable: Decodable {
    static func parse<T: Decodable>(data: Data) throws -> T
    static func parseArray<T: Decodable>(data: Data) throws -> Array<T>
}

extension DataDecodable {
    static func parse<T: Decodable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
    
    static func parseArray<T: Decodable>(data: Data) throws -> Array<T> {
        try JSONDecoder().decode(Array<T>.self, from: data)
    }
}

public class WebAPIManager: WebAPIManagerProtocol {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func perform<T: DataDecodable>(_ request: RequestProtocol) async -> Result<T, APIError> {
        do {
            let data = try await perform(request)
            let decoded: T = try T.parse(data: data)
            return .success(decoded)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error))
        }
    }
    
    func perform<T: DataDecodable>(_ request: RequestProtocol) async -> Result<Array<T>, APIError> {
        do {
            let data = try await perform(request)
            let decoded: Array<T> = try T.parseArray(data: data)
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

