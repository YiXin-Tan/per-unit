//
//  ProductsView.swift
//  per-unit
//
//  Created by yixin on 09/10/2025.
//

import SwiftUI

struct ProductsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var products: FetchedResults<Product>
    @State private var showAddScreen: Bool = false

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ProductsView()
}
