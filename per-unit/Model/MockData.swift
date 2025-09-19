//
//  MockData.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

struct MockData {
    static let sampleCategories: [Category] = [
        Category(name: "Toilet paper"),
        Category(name: "Shapoo"),
        Category(name: "Toothbrush"),
        Category(name: "Coconut milk"),
    ]
    
    static let sampleProduct: Product = Product(
        name: "Palmolive Shampoo Argan Oil",
        price: 3.58,
        amount: 380,
        unit: .ml
    )
}
