//
//  ScanView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct ScanView: View {
    @State private var viewModel = ViewModel()
    @State var isShowingProductDetail: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CameraView(image: $viewModel.currentFrame)
                Button {
                    print("Capture Button Pressed!")
                    isShowingProductDetail = true
                    viewModel.captureAndRecognizeText { recognizedStrings in
                        print("Recognized text: \(recognizedStrings)")
                        // here you could parse recognizedStrings into Product model
                        DispatchQueue.main.async {
                            isShowingProductDetail = true
                        }
                    }
                } label: {
                    Label("Scan", systemImage: "camera.shutter.button.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .foregroundColor(.white)
                .tint(.red)
                
                Text(Product.displayUnitPrice(product: MockData.sampleProduct))

            }.navigationTitle("Scan")
        }
        .sheet(
            isPresented: $isShowingProductDetail,
            content: { ProductDetailView(product: .constant(MockData.sampleProduct))}
        )
    }
}

#Preview {
    ScanView()
}
