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
    var isLoading: Bool { get }
    var searchTerm: String { get set}
    var filteredCatalog: [CatalogPersonEntity] { get }
    func getCatalogVM() async
}

final class CatalogVM: CatalogViewModelType {
    
    @Published private(set) var isLoading = false
    @Published var searchTerm: String = ""
    @Published var catalog: [CatalogPersonEntity] = []
    public let container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?
    private let logger: Loggering?
    private let coreDataManager: DataManagable?
    
    
    var filteredCatalog: [CatalogPersonEntity] {
        let filtered = self.catalog.filter {
            $0.wrappedTitle.lowercased().contains(searchTerm.lowercased()) || $0.wrappedAlias.localizedCaseInsensitiveContains(searchTerm)
        }
        return searchTerm.isEmpty ? self.catalog : filtered
    }
    
    init(container: DIContainerable) {
        self.container = container
        self.networkManager = container.resolve()
        self.logger = container.resolve()
        self.coreDataManager = container.resolve()
    }

    let statusCheck = NetworkStatusService()

    
    func getCatalogVM() async {
        statusCheck.start()
        statusCheck.status = { status in
            print("The status of connection is \(status)")
        }
        
        await fetchCatalog()
        //if catalog.isEmpty { isLoading = true }
        guard let count = await fetchCount() else { return }
        let networkCatalog = await fetchCatalog(count: count)
        //isLoading = false
        for person in networkCatalog {
            guard let entity = catalog.first(where: { $0.id == person.id }) else {
                createCatalogPersonEntity(with: person)
                continue
            }
            entity.update(with: person)
        }
        await fetchCatalog()
    }
    
    func fetchCount() async -> Int? {
        guard let networkManager else { return nil }
        let result: Result<Int, APIError> = await networkManager.perform(CatalogRequest.getCount)
        switch result {
        case .success(let count):
            return count
        case .failure:
            emptyView()
            logger?.log(level: .error, message: "Failure getting count of catalog elements", file: #file)
            // TODO: handle error. Show alert message to user
            return nil
        }
    }
    
    
    func emptyView() {
        if catalog.isEmpty {
            print("Opps. Something goes wrong. Try one more time...")
        }
    }
    
    public func fetchCatalog(count: Int, page: Int = 1) async -> [CatalogPerson] {
        guard let networkManager else { return [] }
        let result: Result<[CatalogPerson], APIError> = await networkManager.perform(CatalogRequest.getCatalog(page: page, count: count))
        switch result {
        case .success(let catalog):
            return catalog
        case .failure:
            emptyView()
            logger?.log(level: .error, message: "Failure of getting catalog elements", file: #file)
            // TODO: handle error. Show alert message to user
            return []
        }
    }
    
    private func fetchCatalog() async {
        let sort = [NSSortDescriptor(key: "title", ascending: true)]
        
//        
//        NSSortDescriptor* sortDescriptior =[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES comparator:^(NSString* str1, NSString* str2) {
//
//        static NSStringCompareOptions comparisonOptions =
//            NSCaseInsensitiveSearch | NSNumericSearch |
//            NSWidthInsensitiveSearch | NSForcedOrderingSearch;
//
//            return [str1 compare:str2 options:comparisonOptions range:NSMakeRange(0, str1.length) locale:[NSLocale localeWithLocaleIdentifier:@"is_IS"]];
//        }]
        
        if let coreDataManager {
            let catalog = coreDataManager.fetch(CatalogPersonEntity.self, sortdescriptors: sort)
            await MainActor.run {
                self.catalog = catalog
            }
        }
    }
    
    
    private func createCatalogPersonEntity(with catalogPerson: CatalogPerson) {
        guard let coreDataManager else { return }
        _ = CatalogPersonEntity(item: catalogPerson, context: coreDataManager.context)
        coreDataManager.save()
        logger?.log(level: .info, message: "New catalogPersonEntity: \(catalogPerson.title) - \(catalogPerson.alias) was created.", file: #file)
    }
    
    private func fetchCatalogCount() -> Int? {
        coreDataManager?.count(CatalogPersonEntity.self)
    }
}



//        guard let networkManager = networkManager else { return }
//    func getCatalogVM() {
//        isLoading = true
//        Task {
//            if let count = await getCount() {
//                let catalog = await getCatalog(count: count)
//                await MainActor.run {
//                    self.catalog = catalog
//                }
//            }
//            isLoading = false
//        }
//    }



//func getCount(networkManager: WebAPIManagerProtocol) async -> Int? {
//        let result: Result<Int, APIError> = await networkManager.perform(CatalogRequest.getCount)
//        switch result {
//        case .success(let count):
//            return count
//        case .failure:
//            logger?.log(level: .error, message: "Failure getting count of catalog elements", file: #file)
//            // TODO: handle error. Show alert message to user
//            return nil
//        }
//    }
//
//    func getCatalog(networkManager: WebAPIManagerProtocol, count: Int, page: Int = 1) async -> [CatalogPerson] {
//        let result: Result<[CatalogPerson], APIError> = await networkManager.perform(CatalogRequest.getCatalog(page: page, count: count))
//        switch result {
//        case .success(let catalog):
//            return catalog
//        case .failure:
//            logger?.log(level: .error, message: "Failure of getting catalog elements", file: #file)
//            // TODO: handle error. Show alert message to user
//            return []
//        }
//    }



//
//var filteredCatalog: [CatalogPersonEntity] {
//    searchTerm.isEmpty ? self.catalog : self.catalog.filter {
//        $0.wrappedTitle.lowercased().contains(searchTerm.lowercased()) || $0.wrappedAlias.localizedCaseInsensitiveContains(searchTerm)
//    }
//    return searchTerm.isEmpty ? self.catalog : filtered
//}


//
//        isLoading = true
//        if let count = await getCount(networkManager: networkManager) {
//            let catalog = await getCatalog(networkManager: networkManager, count: count)
//            await MainActor.run {
//                self.catalog = catalog
//                self.isLoading = false
//            }
//        }
