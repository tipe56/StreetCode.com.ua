//
//  CatalogVM.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

// swiftlint:disable all

import SwiftUI

protocol CatalogViewModelProtocol: ObservableObject {
    var catalog: [CatalogPersonModel] { get }
    func getCatalogVM()
}


final class CatalogVM: CatalogViewModelProtocol {
    
    @Published var catalog: [CatalogPersonModel]
    private let networkManager: WebAPIManagerProtocol
    
    
    init(networkManager: WebAPIManagerProtocol) {
        self.catalog = [CatalogPersonModel]()
        self.networkManager = networkManager
    }
    
    @MainActor
    func getCatalogVM() {
        Task {
            do {
                let count: Int = try await networkManager.perform(CatalogRequest.getCount, parser: DefaultDataParser())
                try await catalog = networkManager.perform(CatalogRequest.getCatalog(page: 1, count: count), parser: DefaultDataParser())
            } catch {
                if let apError = error as? APIError {
                    switch apError {
                    case .invalidURL:
                        print(".invalidURL")
                    case .networkError(let error):
                        print(".networkError")
                    case .invalidServerResponse:
                        print(".invalidServerResponse")
                    case .decodingError(let error):
                        print(".decodingError")
                    }
                } else {
                    print("invalid response")     
                }
            }
        }
        
        //        let result = await networkManager.getCatalog()
        //
        //        switch result {
        //        case .success(let success):
        //            self.catalog = success
        //        case .failure(let failure):
        //            print("")
        //        }
    }
    
    
    //    func getCatalog() {
    //        NetworkManager.shared.getCount { result in
    //            switch result {
    //            case .success(let count):
    //                print(count)
    //                NetworkManager.shared.getCatalog(count: count) { result in
    //                    switch result {
    //                    case .success(let success):
    //                        self.catalog = success
    //                    case .failure(let failure):
    //                        print("falure catalog")
    //                    }
    //                }
    //            case .failure(let failure):
    //                print("falure getCount")
    //            }
    //        }
    //    }
    
    //    func getCount() {
    //        NetworkManager.shared.getCount { result in
    //            switch result {
    //            case .success(let success):
    //                print(success)
    //            case .failure(let failure):
    //                print("get count saparate failure")
    //            }
    //        }
    //    }
    
}

//#if DEBUG
//
//final class CatalogTestVM: CatalogViewModelProtocol {
//    @Published var catalog = [CatalogPersonModel]()
//
//    func getCatalogVM() {
//        catalog = [CatalogPersonModel(id: 12,
//                                       title: "Test Title",
//                                       url: "",
//                                       alias: "Test Alias",
//                                       imageID: 12),
//                   CatalogPersonModel(id: 123,
//                                       title: "Test Title 2",
//                                       url: "",
//                                       alias: "Test Alias 2",
//                                       imageID: 123)]
//    }
//}
//
//#endif
