//
//  CatalogVM.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import SwiftUI
import CoreData

protocol CatalogViewModelType: ObservableObject {
    var catalog: [CatalogPersonEntity] { get }
    var container: DIContainerable { get }
    var searchTerm: String { get set}
    var filteredCatalog: [CatalogPersonEntity] { get }
    func getCatalogVM() async
}

final class CatalogVM: CatalogViewModelType {
    
    // Constants
    public let container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?
    private let logger: Loggering?
    private let coreDataManager: DataManagable?
    
    // Variables
    private var networkStatusService: NetworkStatusServicable?
    var filteredCatalog: [CatalogPersonEntity] {
        let filtered = self.catalog.filter {
            $0.wrappedTitle.lowercased().contains(searchTerm.lowercased()) || $0.wrappedAlias.localizedCaseInsensitiveContains(searchTerm)
        }
        return searchTerm.isEmpty ? self.catalog : filtered
    }
    
    //Published
    @Published var searchTerm: String = ""
    @Published var catalog: [CatalogPersonEntity] = []
    
    
    init(container: DIContainerable) {
        self.container = container
        self.networkManager = container.resolve()
        self.logger = container.resolve()
        self.coreDataManager = container.resolve()
        self.networkStatusService = container.resolve()
    }
    
    func getCatalogVM() async {
        networkStatusService?.start()
        networkStatusService?.status = { status in
            print("The status of connection is \(status)")
        }
        
        readPersonsFromCoreData()
        guard let count = await fetchNetworkCount() else { return }
        let networkCatalog = await fetchCatalog(count: count)
        for person in networkCatalog {
            guard let entity = catalog.first(where: { $0.id == person.id }) else {
                createCatalogPersonEntity(with: person)
                continue
            }
            entity.update(with: person)
        }
        readPersonsFromCoreData()
    }
    
    func fetchNetworkCount() async -> Int? {
        guard let networkManager else { return nil }
        let result: Result<Int, APIError> = await networkManager.perform(CatalogRequest.getCount)
        switch result {
        case .success(let count):
            return count
        case .failure:
            logger?.log(level: .error, message: "Failure getting count of catalog elements", file: #file)
            // TODO: Show alert message to user
            return nil
        }
    }
    
    public func fetchCatalog(count: Int, page: Int = 1) async -> [CatalogPerson] {
        guard let networkManager else { return [] }
        let result: Result<[CatalogPerson], APIError> = await networkManager.perform(CatalogRequest.getCatalog(page: page, count: count))
        switch result {
        case .success(let catalog):
            return catalog
        case .failure:
            logger?.log(level: .error, message: "Failure of getting catalog elements", file: #file)
            // TODO: Show alert message to user
            return []
        }
    }
    
    private func readPersonsFromCoreData() {
        guard let coreDataManager else { return }
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        DispatchQueue.main.async {
            self.catalog = coreDataManager.fetch(CatalogPersonEntity.self, sortdescriptors: [sortDescriptor])
        }
    }
    
    private func createCatalogPersonEntity(with catalogPerson: CatalogPerson) {
        guard let coreDataManager else { return }
        _ = CatalogPersonEntity(item: catalogPerson, context: coreDataManager.context)
        coreDataManager.save()
        logger?.log(level: .info, message: "New catalogPersonEntity: \(catalogPerson.title) - \(catalogPerson.alias) was created.", file: #file)
    }
}
