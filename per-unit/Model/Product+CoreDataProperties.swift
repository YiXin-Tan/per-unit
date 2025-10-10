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

    public var wrappedName: String {
        name ?? ""
    }
    public var wrappedPrice: Double {
        price
    }
    public var wrappedAmount: Double {
        amount
    }
    public var wrappedUnit: String {
        switch unit {
        case 0:
            return "g"
        case 1:
            return "kg"
        case 2:
            return "ml"
        case 3:
            return "l"
        default:
            return "ea"
        }
    }
    public var wrappedCreated: Date { // TODO: set default date, or format to string
        created ?? Date()
    }
    public var wrappedLastModified: Date {
        lastModified ?? Date()
    }
    
    func displayUnitPrice() -> String {
        switch self.unit {
        case 0, 2:
            let rawUnitPrice = self.price / self.amount * 100
            let unitPrice = Double(round(100 * rawUnitPrice) / 100) // round to 2 decimal places
            return "$\(unitPrice) per 100\(self.wrappedUnit)"
        case 1, 3:
            let rawUnitPrice = self.price / self.amount
            let unitPrice = Double(round(100 * rawUnitPrice) / 100)
            return "$\(unitPrice) per 1\(self.wrappedUnit)"
        default:
            return "$\(self.price) per \(self.wrappedUnit)"
        }

    }
    
}

extension Product : Identifiable {

}

//enum Unit: String, CaseIterable, Identifiable {
//    case g = "g" // 0
//    case kg = "kg" // 1
//    case ml = "ml" // 2
//    case l = "l" // 3
//    case ea = "ea" // 4
//    
//    var id: String { rawValue }
//}
