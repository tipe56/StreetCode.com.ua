//
//  CatalogPersonEntity+CoreDataProperties.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.01.24.
//
//

import Foundation
import CoreData


extension CatalogPersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatalogPersonEntity> {
        return NSFetchRequest<CatalogPersonEntity>(entityName: "CatalogPersonEntity")
    }

    @NSManaged public var id: Int16
    var wrappedID: Int { Int(id) }
    @NSManaged public var title: String?
    var wrappedTitle: String { title ?? "No title" }
    @NSManaged public var alias: String?
    var wrappedAlias: String { alias ?? "No alias" }
    @NSManaged public var imageID: Int16
    var wrappedImageID: Int { Int(imageID) }

}

extension CatalogPersonEntity : Identifiable {

}
