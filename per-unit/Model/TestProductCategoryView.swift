//
//  TestProductCategoryView.swift
//  per-unit
//
//  Created by yixin on 09/10/2025.
//

import SwiftUI

struct TestProductCategoryView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var products: FetchedResults<Product>
    @FetchRequest(sortDescriptors: []) var categories: FetchedResults<Category>
    
    var body: some View {
        VStack {
            Button("Create Example Categories") {
                createExampleCategories()
            }
            Button("Create Example Products") {
//                createExampleProducts()
            }
            Button("Delete Everything", role: .destructive) {
                deleteEverything()
            }
            .buttonStyle(.bordered)
        }
    }
    
    func createExampleCategories(){
        let category1 = Category(context: moc)
        category1.id = UUID()
        category1.name = "Toilet Paper"
        category1.lastModified = Date()
        
        let category2 = Category(context: moc)
        category2.id = UUID()
        category2.name = "Shampoo"
        category2.lastModified = Date()
        
        let category3 = Category(context: moc)
        category3.id = UUID()
        category3.name = "Toothbrush"
        category3.lastModified = Date()
        
        let category4 = Category(context: moc)
        category4.id = UUID()
        category4.name = "Coconut milk"
        category4.lastModified = Date()
        
//        try? moc.save()
//    }
//    
//    
//    func createExampleProducts(){
        let product1 = Product(context: moc)
        product1.id = UUID()
        product1.name = "Palmolive Shampoo Argan Oil"
        product1.price = 3.58
        product1.amount = 300
        product1.unit = 2
        product1.created = Date()
        product1.lastModified = Date()
        product1.category = Category(context: moc)
        product1.category?.name = "Shampoo"
        
        let product2 = Product(context: moc)
        product2.id = UUID()
        product2.name = "Johnsons Baby No Tears Shampoo"
        product2.price = 4
        product2.amount = 500
        product2.unit = 2
        product2.created = Date()
        product2.lastModified = Date()
        product2.category = Category(context: moc)
        product2.category?.name = "Shampoo"
        
        try? moc.save()
    }
    
    func deleteEverything(){
        for product in products {
            moc.delete(product)
        }
        for category in categories {
            moc.delete(category)
        }
        
        do {
            try moc.save()
        } catch {
            print("Failed to delete all data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TestProductCategoryView()
}
