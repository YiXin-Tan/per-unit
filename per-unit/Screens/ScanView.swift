//
//  ScanView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct ScanView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        CameraView(image: $viewModel.currentFrame)
        
        
        Button {
            print("Capture Button Pressed!")
        } label: {
            Label("Scan", systemImage: "camera.shutter.button.fill")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .foregroundColor(.white)
        .tint(.red)
        
        Text(Product.displayUnitPrice(product: MockData.sampleProduct))
    }
}

#Preview {
    ScanView()
}
