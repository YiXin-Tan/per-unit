//
//  Product.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import Foundation

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var amount: Double
    var unit: Unit
    // var unitPrice: Double // TODO: to include calculated field, or calculate on the fly?
    var created = Date()
    var lastModified = Date() // capture timestamp when initialised
    
    static func displayUnitPrice(product: Product) -> String {
        switch product.unit {
        case .g, .ml:
            let rawUnitPrice = product.price / product.amount * 100
            let unitPrice = Double(round(100 * rawUnitPrice) / 100) // round to 2 decimal places
            return "$\(unitPrice) per 100\(product.unit)"
        case .kg, .l:
            let rawUnitPrice = product.price / product.amount
            let unitPrice = Double(round(100 * rawUnitPrice) / 100)
            return "$\(unitPrice) per 1\(product.unit)"
        case .ea:
            return "$\(product.price) per \(product.unit)"
        }

    }
}

enum Unit: String, CaseIterable, Identifiable {
    case kg = "kg"
    case g = "g"
    case ml = "ml"
    case l = "l"
    case ea = "ea"
    
    var id: String { rawValue }
}
