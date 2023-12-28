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
    var container: DIContainerable { get }
    func getCatalogVM()
}


final class CatalogVM: CatalogViewModelProtocol {
    
    @Published var catalog: [CatalogPersonModel]
    public let container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?
    
    init(container: DIContainerable) {
        self.container = container
        self.catalog = [CatalogPersonModel]()
        self.networkManager = container.resolve()
    }
    
    func getCatalogVM() {
        Task {
            guard let networkManager else { return }

            let result: Result<Int, APIError> = await networkManager.perform(CatalogRequest.getCount)
            switch result {
            case .success(let count):
                let result: Result<[CatalogPersonModel], APIError> = await networkManager.perform(CatalogRequest.getCatalog(page: 1, count: count))
                switch result {
                case .success(let success):
                    await MainActor.run {
                        catalog = success
                    }
                case .failure:
                    break
                }
            case .failure:
                break
            }
        }
    }
}
