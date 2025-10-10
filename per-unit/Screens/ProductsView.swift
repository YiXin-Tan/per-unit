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
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(product.wrappedName)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(product.displayUnitPrice())")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Text("\(product.wrappedAmount)\(product.wrappedUnit)")
                            Text("$\(product.wrappedPrice)")
                            Text("\(product.wrappedCreated)")
                            Text(product.category?.wrappedName ?? "No category name")
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
            .sheet(isPresented: $showAddScreen, content: { ProductAddView() })
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
