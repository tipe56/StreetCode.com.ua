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
    
    @Published private(set) var catalog: [CatalogPersonEntity] = []
    @Published private(set) var isLoading = false
    @Published var searchTerm: String = ""
    public let container: DIContainerable
    private let networkManager: WebAPIManagerProtocol?
    private let logger: Loggering?
    private let coreDataManager: DataManagable?
    private var networkItemsCatalog: [CatalogPerson] = []
    
    var filteredCatalog: [CatalogPersonEntity] {
        searchTerm.isEmpty ? self.catalog : self.catalog.filter {
            $0.wrappedTitle.lowercased().contains(searchTerm.lowercased()) || $0.wrappedAlias.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    init(container: DIContainerable) {
        self.container = container
        self.networkManager = container.resolve()
        self.logger = container.resolve()
        self.coreDataManager = container.resolve()
    }
    
    func getCatalogVM() async {
        await fetchCatalog()
        guard let networkManager else { return }
        let networkCount = await getCount(networkManager: networkManager)
        if networkCount == fetchCatalogCount() {
            return
        } else {
            guard let networkCount else { return }
            networkItemsCatalog = await getCatalog(networkManager: networkManager, count: networkCount)
            for person in networkItemsCatalog {
                guard let entity = catalog.first(where: { $0.id == person.id }) else {
                    createCatalogPersonEntity(with: person)
                    await fetchCatalog()
                    return
                }
                updateStoredPersonEntity(entity, with: person)
            }
            await fetchCatalog()
        }
//        
//        isLoading = true
//        if let count = await getCount(networkManager: networkManager) {
//            let catalog = await getCatalog(networkManager: networkManager, count: count)
//            await MainActor.run {
//                self.catalog = catalog
//                self.isLoading = false
//            }
//        }
    }
    
//    func getCatalogVM() async {
//        guard let networkManager else { return }
//        isLoading = true
//        if let count = await getCount(networkManager: networkManager) {
//            let catalog = await getCatalog(networkManager: networkManager, count: count)
//            await MainActor.run {
//                self.catalog = catalog
//                self.isLoading = false
//            }
//        }
//    }
    
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
    
    func fetchCatalog() async {
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
    
    func createCatalogPersonEntity(with catalogPerson: CatalogPerson) {
        guard let coreDataManager else { return }
        coreDataManager.createItem(catalogPerson) {_ in
            CatalogPersonEntity(item: catalogPerson, context: coreDataManager.context)
        }
        self.logger?.info("New catalogPersonEntity: \(catalogPerson.title) - \(catalogPerson.alias) was created.")
    }
    
    func updateStoredPersonEntity(_ entity: CatalogPersonEntity, with person: CatalogPerson) {
        coreDataManager?.update(entity) {
            if entity.title != person.title {
                entity.title = person.title
            }
            if entity.alias != person.alias {
                entity.alias = person.alias
            }
            if entity.imageID != Int16(person.imageID){
                entity.imageID = Int16(person.imageID)
            }
        }
    }
    
    func fetchCatalogCount() -> Int? {
        coreDataManager?.count(CatalogPersonEntity.self)
    }
}

