//
//  CatalogVM.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import SwiftUI

protocol CatalogViewModelType: ObservableObject {
    var catalog: [CatalogPerson] { get }
    var container: DIContainerable { get set }
    var isLoading: Bool { get }
    var searchTerm: String { get set}
    var filteredCatalog: [CatalogPerson] { get }
    func getCatalogVM()
}

final class CatalogVM: CatalogViewModelType {
    
    @Published var catalog: [CatalogPerson] = []
    @Published var isLoading = false
    @Published var searchTerm: String = ""
    public var container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?

    var filteredCatalog: [CatalogPerson] {
        searchTerm.isEmpty ? self.catalog : self.catalog.filter {
            $0.title.lowercased().contains(searchTerm.lowercased()) || $0.alias.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    init(container: DIContainerable) {
        self.container = container
        self.networkManager = container.resolve()
    }
    
    func getCatalogVM() {
        isLoading = true
        Task {
            guard let networkManager else { return }
            
            let result: Result<Int, APIError> = await networkManager.perform(CatalogRequest.getCount)
            switch result {
            case .success(let count):
                let result: Result<[CatalogPerson], APIError> = await networkManager.perform(CatalogRequest.getCatalog(page: 1, count: count))
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
