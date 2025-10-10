//
//  ProductsView.swift
//  per-unit
//
//  Created by yixin on 09/10/2025.
//

import SwiftUI

struct ProductsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.created)
    ]) var products: FetchedResults<Product>
    @State private var showAddScreen: Bool = false

    var body: some View {
        NavigationView {
            // TODO: search bar
            List {
                ForEach (products) { product in
                    NavigationLink(destination: ProductDetailView()) {
                        VStack {
                            Text("\(product.wrappedName)")
                            Text("\(product.wrappedAmount)\(product.wrappedUnit)")
                            Text("\(product.displayUnitPrice())")
                            Text("$\(product.wrappedPrice)")
                            Text("\(product.wrappedCreated)")
                        }
                    }
                }
                .onDelete(perform: deleteProducts)
                
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showAddScreen.toggle()
                        // send user to scan view
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    func deleteProducts(at indexes: IndexSet){
        for i in indexes {
            let productToDelete = products[i]
            moc.delete(productToDelete)
        }
        try? moc.save()
    }
}

#Preview {
    ProductsView()
}
