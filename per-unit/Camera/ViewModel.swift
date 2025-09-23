//
//  ViewModel.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//


import Foundation
import CoreImage
import Observation

@Observable
class ViewModel {
    var currentFrame: CGImage?
    var capturedImage: CGImage?
    var recognisedText: [String] = []
    var lastRecognisedText: [String] = [] // Stores the most recent OCR results
    private let cameraManager = CameraManager()
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
            }
        }
    }
    
    func capturePhoto() {
        print("📸 ViewModel: capturePhoto() called")
        cameraManager.capturePhoto(completion: { [weak self] cgImage, recognisedText in
            Task { @MainActor in
                print("📸 ViewModel: Received CGImage from CameraManager: \(cgImage != nil ? "✅" : "❌")")
                self?.capturedImage = cgImage
                self?.lastRecognisedText = recognisedText
                // The OCR will be handled automatically by PhotoCaptureProcessor
                // and the recognised text will be stored in lastRecognisedText

            }
        })
    }
}
