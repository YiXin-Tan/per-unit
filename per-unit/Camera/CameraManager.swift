//
//  CameraManager.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//


import Foundation
import AVFoundation

/// CameraManager.init()
///     ↓
/// configureSession()
///     ↓
/// startSession()
///     ↓
/// captureOutput() [60 FPS]
///     ↓
/// addToPreviewStream()
///     ↓
/// continuation.yield()
///     ↓
/// handleCameraPreviews()
///     ↓
/// currentFrame = image
///     ↓
/// SwiftUI updates CameraView
/// AVCaptureVideoDataOutput calls captureOutput
/// ↓
/// captureOutput called on sessionQueue
/// ↓
/// Frame sent to AsyncStream
/// ↓
/// ViewModel receives frame on main thread (@MainActor)
/// ↓
/// viewModel.currentFrame updates
/// ↓
/// SwiftUI detects change (@Observable)
/// ↓
/// CameraView.image automatically updates (@Binding)
/// ↓
/// CameraView re-renders with new frame
class CameraManager: NSObject {
    // 1.
    private let captureSession = AVCaptureSession()
    // 2.
    private var deviceInput: AVCaptureDeviceInput?
    // 3.
    private var videoOutput: AVCaptureVideoDataOutput?
    private var photoOutput: AVCapturePhotoOutput?
    private var photoSettings: AVCapturePhotoSettings?
    private var currentPhotoProcessor: PhotoCaptureProcessor?
    // 4.
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    // 5.
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    /// Broadcasts frames continuously
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    
    // 1.
    override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    // 2.
    private func configureSession() async {
        // 1.
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        // 2.
        captureSession.beginConfiguration()
        
        // 3.
        defer {
            self.captureSession.commitConfiguration()
        }
        
        // 4.
        let videoOutput = AVCaptureVideoDataOutput()
        let photoOutput = AVCapturePhotoOutput()
        
        // Store outputs and settings as instance variables
        self.videoOutput = videoOutput
        self.photoOutput = photoOutput
        
        // Note: Photo settings will be created fresh for each capture to avoid reuse error
//        photoSettings.flashMode = .auto

        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue) // videoOutput (AVCaptureVideoDataOutput) calls the delegate method everytime
        
        // 5.
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        // 6.
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(photoOutput) else {
            print("❌ Unable to add photo output to capture session")
            return
        }
        
        // 7.
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(photoOutput)
        
        // Set session preset after adding outputs
        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
        }
        
        print("📸 CameraManager: Photo output added to capture session")
        
    }

    
    // 3.

    private func startSession() async {
        guard await isAuthorized else { 
            print("❌ CameraManager: Not authorized to use camera")
            return 
        }
        captureSession.startRunning()
        print("📸 CameraManager: Capture session started")
    }
    
    private func stopSession() async {
        /// Checking authorization
        guard await isAuthorized else { return }
        /// Stop the capture session flow of data
        captureSession.stopRunning()
    }
    
    func takePhoto(completion: @escaping (CGImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: PhotoCaptureProcessor(completion: completion))
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /// Process the frame and send it to the stream
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addToPreviewStream?(currentFrame)
    }
    
}

extension CameraManager {
    /// Creates PhotoCaptureProcessor(Completion:) for every new image
    func capturePhoto(completion: @escaping (CGImage?, [String]) -> Void) {
        guard let photoOutput else {
            print("❌ Photo output is nil")
            completion(nil, [])
            return
        }

        print("📸 Starting photo capture...")

        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Create fresh photo settings each time
            let photoSettings = AVCapturePhotoSettings()
            print("📸 Photo settings created: \(photoSettings)")

            let processor = PhotoCaptureProcessor(completion: { [weak self] cgImage, recognisedText in
                self?.currentPhotoProcessor = nil // Clear the reference when done
                completion(cgImage, recognisedText) // sends back to ViewModel
            })
            
            // Store processor to prevent deallocation
            self.currentPhotoProcessor = processor
            
            // AVCapturePhotoOutput calls processor.photoOutput(...) after photo is captured
            photoOutput.capturePhoto(with: photoSettings, delegate: processor)
        }
    }
}

// Helper delegate object (so multiple captures can work independently)
private class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    let completion: (CGImage?) -> Void

    init(completion: @escaping (CGImage?) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil,
              let cgImage = photo.cgImageRepresentation()
        else {
            completion(nil)
            return
        }
        completion(cgImage)
    }
}




// REFERENCES
// https://www.createwithswift.com/camera-capture-setup-in-a-swiftui-app/
// https://developer.apple.com/documentation/avfoundation/capture-setup
