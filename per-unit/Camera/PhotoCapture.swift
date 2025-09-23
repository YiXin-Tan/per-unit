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
    private let completion: (CGImage?) -> Void
    
    init(completion: @escaping (CGImage?) -> Void) {
        self.completion = completion
        super.init()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("📸 PhotoCaptureProcessor: didFinishProcessingPhoto called")
        
        if let error = error {
            print("❌ Error capturing photo: \(error)")
            completion(nil)
            return
        }
        
        guard let cgImage = photo.cgImageRepresentation() else {
            print("❌ Unable to get CGImage from photo")
            completion(nil)
            return
        }
        
        print("✅ Successfully captured CGImage: \(cgImage.width)x\(cgImage.height)")
        
        // Run OCR on the captured image
        runOCR(cgImage: cgImage)
        
        // Pass the CGImage to the completion handler
        completion(cgImage)
    }
    
    func runOCR(cgImage: CGImage) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            try requestHandler.perform([request])
        } catch {
            print("❌ OCR failed: \(error)")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        print("📝 Recognized text: \(recognizedStrings)")
    }
}