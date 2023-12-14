//
//  NetworkManager.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import UIKit

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case enableToComplete
}

enum APIRequest {
    case getCount
    case getCatalog
    
    var rawValue: (url: String, type: Decodable.Type) {
        switch self {
        case .getCount :
            return ("/streetcode/getCount", Int.self)
        case .getCatalog:
            return ("/streetcode/getCatalog", [CatalogPreviewModel].self)
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseApiURL = "https://backend.streetcode.com.ua/api"
    private var getCountUrl: String { baseApiURL + "/streetcode/getCount" }
    private var getCatalogUrl: String { baseApiURL + "/streetcode/getAllCatalog?page=1&count=" }
    
    private init() { }
    

    func get<T: Decodable>(additionTobaseURL: String = "", decodeType: T.Type, completed: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: baseApiURL + additionTobaseURL) else {
             completed(.failure(.invalidURL))
                print("invalid catalog url")
             return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.enableToComplete))
                print("invalid catalog session")
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                print("invalid catalog response")
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                print("invalid catalog data")
                return
            }

            do {
                let decoder = JSONDecoder()
                let decoderResponse = try decoder.decode(T.self, from: data)
                completed(.success(decoderResponse))
            } catch {
                print("decode catalog")
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
}





