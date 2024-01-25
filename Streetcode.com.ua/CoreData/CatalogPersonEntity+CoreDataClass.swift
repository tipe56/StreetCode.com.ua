//
//  CatalogPersonEntity+CoreDataClass.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.01.24.
//
//

import Foundation
import CoreData

@objc(CatalogPersonEntity)
public class CatalogPersonEntity: NSManagedObject {
    convenience init(item: CatalogPerson, context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = Int16(item.id)
        self.title = item.title
        self.alias = item.alias
        self.imageID = Int16(item.imageID)
        do {
            try context.save()
        } catch {
            print("error saving new entity")
        }
    }
}


extension CatalogPersonEntity {
    func update(with object: CatalogPerson) {
        self.title = object.title
        self.alias = object.alias
        self.imageID = Int16(object.imageID)
    }
}



