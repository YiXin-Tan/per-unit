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
            ZStack {
                CameraView(image: $viewModel.currentFrame)
                    .ignoresSafeArea()
                

                VStack {
                    Spacer()
                    
                    Button {
                        print("Capture Button Pressed!")
                        viewModel.capturePhoto()
                        isShowingProductDetail = true
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
                ProductDetailView()
            }
        )
    }
}

#Preview {
    ScanView()
}
