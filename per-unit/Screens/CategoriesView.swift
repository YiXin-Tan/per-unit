//
//  CategoriesView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct CategoriesView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var products: FetchedResults<Product>

    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                Section(category.wrappedName){
                    ForEach(category.productArray, id: \.self) { product in
                        Text(product.wrappedName)
                    }
                }
                
            }
        }
    }
}

#Preview {
    CategoriesView()
}
