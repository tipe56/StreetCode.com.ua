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
    case invalidResponse
    case invalidData
    case enableToComplete
}

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
    func parseJSON<T: Decodable>(data: Data) throws -> T
}

extension DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T {
        try parseJSON(data: data)
    }
    
    func parseJSON<T: Decodable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}

private class DefaultDataParser: DataParserProtocol {}

protocol WebAPIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
    func perform<T: Decodable>(
        _ request: RequestProtocol,
        parser: DataParserProtocol
    ) async throws -> T
}

public class WebAPIManager: WebAPIManagerProtocol {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.makeURLRequest())
        guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }
    
    func perform<T: Decodable>(
        _ request: RequestProtocol,
        parser: DataParserProtocol = DefaultDataParser()
    ) async throws -> T {
        let data = try await perform(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
//    func getCatalog() async -> Result<[CatalogPersonModel],APIError> {
//        let count: Result<Int, APIError> = await get(with: .getCount)
//        switch count {
//        case .success(let count):
//            let catalog: Result<[CatalogPersonModel],APIError> = await get(with: .getCatalog(page: 1, count: count))
//            return catalog
//        case .failure(let failure):
//            return .failure(.invalidData)
//        }
//    }
    
//    func get<T: Decodable>(with api: CatalogRequest) async -> Result<T, APIError> {
//        var result: (data: Data, response: URLResponse)?
//        do {
//            result = try await URLSession.shared.data(for: api.request)
//            
//            guard let response = result?.response as? HTTPURLResponse,
//                    response.statusCode == 200 else {
//                return .failure(.invalidResponse)
//            }
//        } catch {
//            return .failure(.invalidResponse)
//        }
//
//        do {
//            guard let data = result?.data else { return .failure(.invalidData) }
//
//            let decoder = JSONDecoder()
//            let decoderResponse = try decoder.decode(T.self, from: data)
//            
//            return .success(decoderResponse)
//        } catch {
//            return .failure(.invalidData)
//        }
//    }
    
//    func get<T: Decodable>(_ request: APIRequest, query: String = "", completed: @escaping (Result<T, APIError>) -> Void) {
//        let urlString = request.endPointUrlString + query
//        
//        guard let url = URL(string: urlString) else {
//            completed(.failure(.invalidURL))
//            print("invalid catalog url")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            if let _ = error {
//                completed(.failure(.enableToComplete))
//                print("invalid catalog session")
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                print("invalid catalog response")
//                return
//            }
//            
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                print("invalid catalog data")
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let decoderResponse = try decoder.decode(T.self, from: data)
//                completed(.success(decoderResponse))
//            } catch {
//                print("decode catalog")
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
 
}
