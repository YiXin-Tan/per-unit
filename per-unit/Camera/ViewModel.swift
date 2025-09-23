//
//  ViewModel.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//


import Foundation
import CoreImage
import Observation
import Vision

@Observable
class ViewModel {
    var currentFrame: CGImage?
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
    
    func captureAndRecognizeText(completion: @escaping ([String]) -> Void) {
        cameraManager.takePhoto { cgImage in
            guard let cgImage else {
                completion([])
                return
            }
            self.recognizeText(from: cgImage, completion: completion)
        }
    }

    private func recognizeText(from cgImage: CGImage, completion: @escaping ([String]) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([])
                return
            }
            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
            completion(recognizedStrings)
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
}
