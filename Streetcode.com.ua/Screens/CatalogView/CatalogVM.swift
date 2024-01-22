//
//  CatalogVM.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import SwiftUI

protocol CatalogViewModelType: ObservableObject {
    var catalog: [CatalogPerson] { get }
    var container: DIContainerable { get }
    var isLoading: Bool { get }
    var searchTerm: String { get set}
    var filteredCatalog: [CatalogPerson] { get }
    func getCatalogVM() async
}

final class CatalogVM: CatalogViewModelType {
    
    @Published private(set) var catalog: [CatalogPerson] = []
    @Published private(set) var isLoading = false
    @Published var searchTerm: String = ""
    public let container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?
    private let logger: Loggering?
    
    var filteredCatalog: [CatalogPerson] {
        searchTerm.isEmpty ? self.catalog : self.catalog.filter {
            $0.title.lowercased().contains(searchTerm.lowercased()) || $0.alias.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    init(container: DIContainerable) {
        self.container = container
        self.networkManager = container.resolve()
        self.logger = container.resolve()
    }
    
    func getCatalogVM() async {
        guard let networkManager else { return }
        isLoading = true
        if let count = await getCount(networkManager: networkManager) {
            let catalog = await getCatalog(networkManager: networkManager, count: count)
            await MainActor.run {
                self.catalog = catalog
                self.isLoading = false
            }
        }
    }
    
    func getCount(networkManager: WebAPIManagerProtocol) async -> Int? {
        let result: Result<Int, APIError> = await networkManager.perform(CatalogRequest.getCount)
        switch result {
        case .success(let count):
            return count
        case .failure:
            logger?.error("Failure getting count of catalog elements")
            // TODO: handle error. Show alert message to user
            return nil
        }
    }
    
    
    func getCatalog(networkManager: WebAPIManagerProtocol, count: Int, page: Int = 1) async -> [CatalogPerson] {
        let result: Result<[CatalogPerson], APIError> = await networkManager.perform(CatalogRequest.getCatalog(page: page, count: count))
        switch result {
        case .success(let catalog):
            return catalog
        case .failure:
            logger?.error("Failure of getting catalog elements")
            // TODO: handle error. Show alert message to user
            return []
        }
    }
}

