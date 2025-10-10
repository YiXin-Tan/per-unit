//
//  ProductAddView.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import SwiftUI

struct ProductAddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.lastModified)
    ]) var categories: FetchedResults<Category>
    let units = ["g", "kg", "ml", "l", "ea"]
    @State var name = ""
    @State var price: Double?
    @State var amount: Double?
    @State var unit = "g"
    @State var category: Category?

    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                
                TextField("Price", value: $price, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                
                Picker("Unit", selection: $unit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section {
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.wrappedName)
                            .tag(Optional(category)) // wrap each as optional since $category is optional
                    }
                }
                .pickerStyle(.menu)
                
                // TODO: New category button, which shows add category popup
            }
            
            Section {
                Button("Save"){
                    Product.createNewProduct(
                        name: name,
                        price: price ?? 0.0,
                        amount: amount ?? 0.0,
                        unit: unit,
                        category: category ?? Category(context: moc),
                        context: moc
                    )
//                    let newProduct = Product(context: moc)
//                    newProduct.id = UUID()
//                    newProduct.name = name
//                    newProduct.price = price ?? 0.0
//                    newProduct.amount = amount ?? 0.0
//                    newProduct.unit = 3
//                    newProduct.created = Date()
//                    newProduct.lastModified = Date()
//                    newProduct.category = category
                    
                    try? moc.save()
                    dismiss()
                }
            }
        }
    }
}

