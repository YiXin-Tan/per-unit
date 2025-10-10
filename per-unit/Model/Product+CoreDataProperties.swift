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
    public var wrappedPrice: String {
        String(format: "%.2f", price)
        // return (price * 100).rounded() / 100
    }
    public var wrappedAmount: String {
        String(format: "%.0f", amount)
    }
    public var wrappedUnit: String {
        switch unit {
        case 0:
            return "g"
        case 1:
            return "kg"
        case 2:
            return "mL"
        case 3:
            return "L"
        default:
            return "ea"
        }
    }
    public var wrappedCreated: String {
        let dateToFormat = created ?? Date()
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(dateToFormat) ||
           calendar.isDate(dateToFormat, equalTo: Date(), toGranularity: .weekOfYear) {
            // Within the last 7 days (same week)
            formatter.dateFormat = "EEEE h:mma" // e.g., Monday 3:35PM
        } else {
            // Older than 7 days
            formatter.dateFormat = "d/M/yyyy h:mma" // e.g., 31/7/2025 3:35PM
        }
        
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter.string(from: dateToFormat)
    }
    
    public var wrappedLastModified: Date {
        lastModified ?? Date()
    }
    
    func displayUnitPrice() -> String {
        switch self.unit {
        case 0, 2:
            let rawUnitPrice = self.price / self.amount * 100
            let unitPrice = Double(round(100 * rawUnitPrice) / 100) // round to 2 decimal places
            return "$\(unitPrice)/100\(self.wrappedUnit)"
        case 1, 3:
            let rawUnitPrice = self.price / self.amount
            let unitPrice = Double(round(100 * rawUnitPrice) / 100)
            return "$\(unitPrice)/1\(self.wrappedUnit)"
        default:
            return "$\(self.price)/\(self.wrappedUnit)"
        }
    }
    
    static func createNewProduct(
        name: String,
        price: Double,
        amount: Double,
        unit: String,
        category: Category,
        context: NSManagedObjectContext
    ) {
        let newProduct = Product(context: context)
        newProduct.id = UUID()
        newProduct.name = name
        newProduct.price = price
        newProduct.amount = amount
        newProduct.unit = Int16(unitIndex(for: unit))
        newProduct.created = Date()
        newProduct.lastModified = Date()
        newProduct.category = category

        try? context.save()
}
    
    static func createNewProduct(
        productData: ProductData,
        context: NSManagedObjectContext
    ){
        do {
            var productInfo = try productData.choices[0].message.getProductInfo()
            return Product.createNewProduct(
                name: productInfo.productName,
                price: productInfo.price,
                amount: productInfo.amount,
                unit: productInfo.unit,
                category: Category(context: context), // TODO: recognise category
                context: context
            )
        } catch {
            print(error) // TODO: handle error
        }
    }
    
    private static func unitIndex(for unit: String) -> Int {
        switch unit {
        case "g": return 0
        case "kg": return 1
        case "ml": return 2
        case "l": return 3
        default: return 4
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
