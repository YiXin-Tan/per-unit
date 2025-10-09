//
//  Product+CoreDataProperties.swift
//  per-unit
//
//  Created by yixin on 09/10/2025.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var amount: Double
    @NSManaged public var unit: Int16
    @NSManaged public var created: Date?
    @NSManaged public var lastModified: Date?
    @NSManaged public var category: Category?

}

extension Product : Identifiable {

}
