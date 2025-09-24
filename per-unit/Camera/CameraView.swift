//
//  CameraView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//


import SwiftUI

struct CameraView: View {
    
    @Binding var image: CGImage? // Bound to viewModel.currentFrame
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(90)) // adjust as needed
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            } else {
                ContentUnavailableView("No camera feed", systemImage: "xmark.circle.fill")
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            }
        }
    }
    
}
