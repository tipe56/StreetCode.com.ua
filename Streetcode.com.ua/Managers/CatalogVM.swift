//
//  CatalogVM.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import SwiftUI

final class CatalogVM: ObservableObject {
    
    @Published var catalog = [CatalogPreviewModel]()
    
    
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
    
    func genericGet() {
        NetworkManager.shared.get(additionTobaseURL: "/streetcode/getCount", decodeType: Int.self) { result in
            switch result {
            case .success(let success):
                NetworkManager.shared.get(additionTobaseURL: "/streetcode/getAllCatalog?page=1&count=\(success)", decodeType: [CatalogPreviewModel].self) { result in
                    switch result {
                    case .success(let success):
                        // Create an instance of the array from the decoded type
                        self.catalog = success
                    case .failure(let failure):
                        print("Catalog failure: \(failure)")
                    }
                }
            case .failure(let failure):
                print("Count failure: \(failure)")
            }
        }
    }
}

