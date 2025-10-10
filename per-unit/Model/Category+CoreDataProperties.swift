//
//  Category+CoreDataProperties.swift
//  per-unit
//
//  Created by yixin on 09/10/2025.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var lastModified: Date?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var products: NSSet?

    public var wrappedName: String {
        name ?? "Unknown Category Name"
    }
    
    public var wrappedLastModified: Date {
        lastModified ?? Date()
    }
    
    public var productArray: [Product] {
        let set = products as? Set<Product> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for products
extension Category {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension Category : Identifiable {

}
