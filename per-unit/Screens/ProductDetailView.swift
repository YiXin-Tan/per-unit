//
//  ProductDetailView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct ProductDetailView: View {
    
    @Binding var product: Product

    var body: some View {
        // TODO: persist data
        Form {
            Section(header: Text("Product Details")) {
                LabeledContent {
                    TextField("name", text: $product.name)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Name")
                }

                LabeledContent {
                    TextField(
                        "Enter price",
                        text: Binding(
                            get: { String(product.price) },
                            set: { product.price = Double($0) ?? product.price }
                        )
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("Price")
                }
                
                LabeledContent {
                    TextField(
                        "Enter amount",
                        text: Binding(
                            get: { String(product.amount) },
                            set: {
                                product.amount = Double($0) ?? product.amount
                            }
                        )
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)

                    // TODO: add unit behind amount
                } label: {
                    Text("Amount")
                }

                Picker("Unit", selection: $product.unit) {
                    ForEach(Unit.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(.menu)
            }

        }
    }
}

#Preview {
    ProductDetailView(product: .constant(MockData.sampleProduct))
}
