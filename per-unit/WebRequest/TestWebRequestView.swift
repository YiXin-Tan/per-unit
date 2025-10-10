//
//  TestWebRequestView.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import SwiftUI

struct TestWebRequestView: View {
    @Environment(\.managedObjectContext) var moc
    @State var productData: ProductData?
    @State var productInfo: ProductInfo?
    var body: some View {
        VStack {
            Text(productData?.model ?? "model placeholder")
            
            Text(productInfo?.productName ?? "product name placeholder")
            Text("\(productInfo?.price ?? 0.0)")
            Text("\(productInfo?.amount ?? 0.0)")
            Text(productInfo?.unit ?? "product unit placeholder")
        }
        .task {
            do {
                productData = try await getProductData(rawText: "$ 599\nWILLOWTON FREE RANGE\nFree Range Fresh Whole Chicken\nper kg\n$5.99 per kg\nD 399578-KGM")
                productInfo = try productData?.choices[0].message.getProductInfo()
                Product.createNewProduct(productData: productData!, context: moc)

            } catch WebRequestError.invalidURL {
                print("Invalid URL")
            } catch WebRequestError.invalidResponse {
                print("Invalid response")
            } catch WebRequestError.invalidData {
                print("Invalid data")
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
}

#Preview {
    TestWebRequestView()
}
