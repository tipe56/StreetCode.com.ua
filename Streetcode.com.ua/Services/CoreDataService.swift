//
//  DataManager.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.01.24.
//

import SwiftUI
import CoreData

protocol DataManagable {
    var context: NSManagedObjectContext { get }
    
    func createItem<T, A>(_ item: T, mapping: @escaping (T) -> A?) where T: Codable, A: NSManagedObject
    
    func fetch<T: NSManagedObject>(_ entity: T.Type, sortdescriptors: [NSSortDescriptor]?) -> [T]
    func update<T: NSManagedObject>(_ item: T, _ update: @escaping () -> Void)
    func delete<T : NSManagedObject>(item: T)
    func delete<T: NSManagedObject>(entities: [T], indexSet: IndexSet)
    func count<T: NSManagedObject>(_ entity: T.Type) -> Int?
    func save()
}

final class CoreDataService: NSObject, ObservableObject, DataManagable {
    private let logger: Loggering
    private let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext
    
    init(persistentContainerName: String = "Streetcode", logger: Loggering) {
        self.persistentContainer = NSPersistentContainer(name: persistentContainerName)
        self.context = persistentContainer.viewContext
        self.logger = logger
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                logger.log(level: .error, message: "Error loading CoreData: \(error)", file: #file)
            }
        }
    }
    
    
    func createItem<T, A>(_ item: T, mapping: @escaping (T) -> A?) where T: Codable, A: NSManagedObject {
        _ = mapping(item)
        save()
    }
    
    func fetch<T: NSManagedObject>(_ entity: T.Type, sortdescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        if let sortdescriptors {
            request.sortDescriptors = sortdescriptors
        }
        
        do {
            return try self.context.fetch(request)
        } catch let error {
            logger.log(level: .error, message: "Error fetching data: \(error)", file: #file)
        }
        return []
    }

/*
    func update<T: NSManagedObject>(_ item: T, _ update: @escaping (T) -> Void) {
        do {
            let object = try context.existingObject(with: item.objectID)
            update(object as! T)
        } catch let error {
            print(error.localizedDescription)
        }
//        let object = context.object(with: item.objectID)
//        update(object as! T)
        saveContext()
    }
 */
    
    func update<T: NSManagedObject>(_ item: T, _ update: @escaping () -> Void) {
        update()
        save()
    }
//    
//    func update(entity: CatalogPersonEntity) {
//        do {
//            let object = try context.existingObject(with: entity.objectID)
//            object.setValue("Alex", forKey: "title")
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        let object = context.object(with: entity.objectID)
//        object.setValue("Alex", forKey: "title")
//        saveContext()
//    }
    
    func delete<T : NSManagedObject>(item: T) {
        self.context.delete(item)
        save()
    }
    
    func delete<T: NSManagedObject>(entities: [T], indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = entities[index]
        delete(item: entity)
        save()
    }
    
    public func save() {
        if self.context.hasChanges {
            do {
                try context.save()
            } catch let error {
                logger.log(level: .error, message: "Error of saving context to CoreData: \(error.localizedDescription)", file: #file)
            }
        }
    }
    
    func count<T: NSManagedObject>(_ entity: T.Type) -> Int? {
        do {
            return try self.context.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity)))
        } catch let error {
            logger.log(level: .error, message: "Error of getting entity count from CoreData: \(error.localizedDescription)", file: #file)
        }
        return nil
    }
}
