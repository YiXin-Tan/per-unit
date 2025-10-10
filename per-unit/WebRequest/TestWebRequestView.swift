//
//  TestWebRequestView.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import SwiftUI

struct TestWebRequestView: View {
    @State var productData: ProductData?
    var body: some View {
        VStack {
            Text(productData?.login ?? "Login placeholder")
            
            Text(productData?.bio ?? "Bio placeholder")
        }
        .task {
            do {
                productData = try await getProductDetails()
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
