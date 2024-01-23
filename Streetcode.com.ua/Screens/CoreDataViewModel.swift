//
//  CoreDataViewModel.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 22.01.24.
//

import SwiftUI

class CoreDataViewModel: ObservableObject {
    
    let dataManager: DataManagable?
    @Published var listData: [CatalogPersonEntity] = []
    
    var catalogVM: any CatalogViewModelType
    @Published var catalogOfPersons: [CatalogPerson] = []
    
    init(container: DIContainerable) {
        self.catalogVM = CatalogVM(container: container)
        self.dataManager = container.resolve()
    }
    
    func delete(indexSet: IndexSet) {
        dataManager?.delete(entities: listData, indexSet: indexSet)
        fetch()
    }
     
    func addHero(text: String) {
        let newHero = CatalogPerson(id: Int.random(in: 0...999),
                                    title: text,
                                    url: text,
                                    alias: text,
                                    imageID: Int.random(in: 0...999))
        createEntity(newHero)
        dataManager.saveContext()

        self.dataManager?.createItem(newHero) { _ in
            self.createEntity(newHero)
        }
    }
    
    func convertPersonsToEntities() {
        dataManager?.createEntityFromArray(catalogOfPersons) { item in
            self.createEntity(item) }
    }
    
    func createEntity(_ item: CatalogPerson) -> CatalogPersonEntity? {
        guard let context = dataManager?.context else { return nil }
        return CatalogPersonEntity(item: item, context: context)
    }
    
    //    func update(entity: CatalogPersonEntity) {
    //        dataManager.update(entity) { _ in
    //            <#code#>
    //        }
    //        fetch()
    //    }
    
    func fetch() {
        let sort = [NSSortDescriptor(key: "title", ascending: true)]
        if let dataManager {
            listData = dataManager.fetch(CatalogPersonEntity.self, sortdescriptors: sort)
        }
        
    }
}
