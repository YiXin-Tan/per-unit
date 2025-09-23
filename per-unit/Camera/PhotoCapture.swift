//
//  PhotoCapture.swift
//  per-unit
//
//  Created by yixin on 22/09/2025.
//

import Foundation
import AVFoundation
import Vision
import CoreImage

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (CGImage?, [String]) -> Void
    
    init(completion: @escaping (CGImage?, [String]) -> Void) {
        self.completion = completion
        super.init()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("📸 PhotoCaptureProcessor: didFinishProcessingPhoto called")
        
        if let error = error {
            print("❌ Error capturing photo: \(error)")
            completion(nil, [])
            return
        }
        
        guard let cgImage = photo.cgImageRepresentation() else {
            print("❌ Unable to get CGImage from photo")
            completion(nil, [])
            return
        }
        
        print("✅ Successfully captured CGImage: \(cgImage.width)x\(cgImage.height)")
        
        // Run OCR on the captured image
        runOCR(cgImage: cgImage, completion: { [weak self] recognisedText in
            // Pass both CGImage and recognised text to completion
            self?.completion(cgImage, recognisedText) // sends back to CameraManager
        })
    }
    
    func runOCR(cgImage: CGImage, completion: @escaping ([String]) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([])
                return
            }
            let recognisedStrings = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
            
            print("📝 Recognised text: \(recognisedStrings)")
            completion(recognisedStrings)
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("❌ OCR failed: \(error)")
            completion([])
        }
    }
}
