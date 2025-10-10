//
//  ScanView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct ScanView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var viewModel = ViewModel()
    @State var isShowingProductDetail: Bool = false
    @State var isProcessing: Bool = false
    @State var errorMessage: String?
//    @State var newProduct: Product?
    
    var body: some View {
        NavigationStack {
            ZStack {
                CameraView(image: $viewModel.currentFrame)
                    .ignoresSafeArea()
                

                VStack {
                    Spacer()
                    
                    Button {
                        Task {
                            await handleScan()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.shutter.button.fill")
                            Text("Scan")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 30)
                        .foregroundColor(.white)
                        .background(.ultraThinMaterial, in: Capsule())
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.25))
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 32)
                }

//                .foregroundColor(.white)
//                .tint(.red)
                
//                Text(Product.displayUnitPrice(product: MockData.sampleProduct))

            }//.navigationTitle("Scan")
        }
        .sheet(
            isPresented: $isShowingProductDetail,
            content: {
//                ProductDetailView(
//                    product: .constant(MockData.sampleProduct),
//                    recognisedText: viewModel.lastRecognisedText
//                )
//                ProductDetailView(product: $newProduct)
                ProductsView()
            }
        )
    }
    
    private func handleScan() async {
        isProcessing = true
        errorMessage = nil
        
        do {
            // Step 1: Capture photo and recognize text
            print("Step 1: Capturing photo...")
            viewModel.capturePhoto()
            
            // Wait a bit for text recognition to complete
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            let recognisedTexts = viewModel.recognisedText
            let recognisedText = joinStringsWithNewlines(recognisedTexts)
            
            print("Step 2: Recognized text: \(recognisedText)")
            
            // Step 2: Get product data from API
            print("Step 3: Fetching product data from API...")
            let productData = try await getProductData(rawText: recognisedText)
            
            // Step 3: Extract product info
            print("Step 4: Extracting product info...")
            let productInfo = try productData.choices[0].message.getProductInfo()
            
            // Step 4: Create new product in Core Data
            await MainActor.run {
                Product.createNewProduct(productData: productData, context: moc)
                isProcessing = false
                isShowingProductDetail = true
            }
            
        } catch WebRequestError.invalidURL {
            await MainActor.run {
                errorMessage = "Invalid API URL"
                isProcessing = false
            }
        } catch WebRequestError.invalidResponse {
            await MainActor.run {
                errorMessage = "Invalid API response"
                isProcessing = false
            }
        } catch WebRequestError.invalidData {
            await MainActor.run {
                errorMessage = "Invalid data received"
                isProcessing = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Unexpected error: \(error.localizedDescription)"
                isProcessing = false
            }
        }
    }
}
//
//#Preview {
//    ScanView()
//}
