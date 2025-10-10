//
//  ProductDetailView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct ProductDetailView: View {
    
//    @Binding var product: Product?
//    var recognisedText: [String]

    var body: some View {
//        VStack {
//            Text(product?.name ?? "product name placeholder")
//        }
        // TODO: persist data
//        VStack {
//            Form {
//                Section(header: Text("Product Details")) {
//                    LabeledContent {
//                        TextField("name", text: $product.name)
//                            .multilineTextAlignment(.trailing)
//                    } label: {
//                        Text("Name")
//                    }
//                    
//                    LabeledContent {
//                        TextField(
//                            "Enter price",
//                            text: Binding(
//                                get: { String(product.price) },
//                                set: { product.price = Double($0) ?? product.price }
//                            )
//                        )
//                        .keyboardType(.decimalPad)
//                        .multilineTextAlignment(.trailing)
//                    } label: {
//                        Text("Price")
//                    }
//                    
//                    LabeledContent {
//                        TextField(
//                            "Enter amount",
//                            text: Binding(
//                                get: { String(product.amount) },
//                                set: {
//                                    product.amount = Double($0) ?? product.amount
//                                }
//                            )
//                        )
//                        .keyboardType(.decimalPad)
//                        .multilineTextAlignment(.trailing)
//                        
//                        // TODO: add unit behind amount
//                    } label: {
//                        Text("Amount")
//                    }
//                    
//                    Picker("Unit", selection: $product.unit) {
//                        ForEach(Unit.allCases) { unit in
//                            Text(unit.rawValue).tag(unit)
//                        }
//                    }
//                    .pickerStyle(.menu)
//                }
//                
//            }
//            
//            ForEach(recognisedText, id: \.self) { text in
//                Text(text)
//                    .font(.caption)
//            }
//        }
    }
}

//#Preview {
////    ProductDetailView(product: .constant(MockData.sampleProduct), recognisedText: ["str1", "str2"])
//    ProductDetailView()
//}
