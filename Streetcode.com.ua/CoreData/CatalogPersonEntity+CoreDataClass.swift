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
    
    init(item: CatalogPerson, context: NSManagedObjectContext) {
        super.init(entity: Self.entity(), insertInto: context)
        self.id = Int16(item.id)
        self.title = item.title
        self.alias = item.alias
        self.imageID = Int16(item.imageID)
    }
    
}
