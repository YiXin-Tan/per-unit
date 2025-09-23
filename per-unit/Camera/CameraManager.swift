//
//  CameraManager.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//


import Foundation
import AVFoundation

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

        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
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
        
        print("✅ Photo output can be added to capture session")
        
        // 7.
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(photoOutput)
        
        // Set session preset after adding outputs
        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
            print("✅ Session preset set to .photo")
        } else {
            print("⚠️ Cannot set session preset to .photo, using default")
        }
        
        print("📸 CameraManager: Photo output added to capture session")
        print("📸 CameraManager: Photo output isRunning: \(captureSession.isRunning)")
        
    }

    
    // 3.

    private func startSession() async {
        /// Checking authorization
        guard await isAuthorized else { 
            print("❌ CameraManager: Not authorized to use camera")
            return 
        }
        /// Start the capture session flow of data
        captureSession.startRunning()
        print("📸 CameraManager: Capture session started")
    }
    
    private func stopSession() async {
        /// Checking authorization
        guard await isAuthorized else { return }
        /// Stop the capture session flow of data
        captureSession.stopRunning()
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addToPreviewStream?(currentFrame)
    }
    
}

extension CameraManager {
    func capturePhoto(completion: @escaping (CGImage?) -> Void) {
        guard let photoOutput else { 
            print("❌ Photo output is nil")
            completion(nil)
            return 
        }

        print("📸 Capture session isRunning: \(captureSession.isRunning)")
        print("📸 Photo output connections: \(photoOutput.connections.count)")
        print("📸 Available photo codec types: \(photoOutput.availablePhotoCodecTypes)")

        // Ensure we're on the session queue for photo capture
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Create fresh photo settings each time to avoid reuse error
            // Use default settings for maximum compatibility
            let photoSettings = AVCapturePhotoSettings()
            print("📸 Using default photo settings")
            
            // Enable high resolution photos if supported
            if photoOutput.isHighResolutionCaptureEnabled {
                photoSettings.isHighResolutionPhotoEnabled = true
                print("📸 High resolution photos enabled")
            }
            
            print("📸 Photo settings created: \(photoSettings)")

            let processor = PhotoCaptureProcessor { [weak self] cgImage in
                self?.currentPhotoProcessor = nil // Clear the reference when done
                completion(cgImage)
            }
            
            // Store the processor to prevent deallocation
            self.currentPhotoProcessor = processor
            
            print("📸 Starting photo capture on session queue...")
            photoOutput.capturePhoto(with: photoSettings, delegate: processor)
            
            // Add a timeout to detect if delegate never gets called
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("⚠️ Photo capture timeout - delegate may not have been called")
            }
        }
    }
}




// REFERENCES
// https://www.createwithswift.com/camera-capture-setup-in-a-swiftui-app/
// https://developer.apple.com/documentation/avfoundation/capture-setup
