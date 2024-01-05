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
    var isLoading: Bool { get }
    var searchTerm: String { get set}
    var filteredCatalog: [CatalogPersonModel] { get }
    func getCatalogVM()
}

final class CatalogVM: CatalogViewModelProtocol {
    
    @Published var catalog: [CatalogPersonModel]
    @Published var isLoading = false
    @Published var searchTerm: String = ""
    public let container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?
    
    var filteredCatalog: [CatalogPersonModel] {
        searchTerm.isEmpty ? self.catalog : self.catalog.filter {
            $0.title.lowercased().contains(searchTerm.lowercased()) || $0.alias.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    init(container: DIContainerable) {
        self.container = container
        self.catalog = [CatalogPersonModel]()
        self.networkManager = container.resolve()
    }
    
    func getCatalogVM() {
        isLoading = true
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
                        isLoading = false
                    }
                case .failure:
                    break
                    // TODO: handle error. Show alert message
                }
            case .failure:
                break
                // TODO: handle error. Show alert message
            }
        }
    }
}
