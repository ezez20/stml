//
//  FrameHandler.swift
//  stml
//
//  Created by Ezra Yeoh on 7/20/23.
//

import AVFoundation
import CoreImage

class CameraFrameHandler: NSObject, ObservableObject {
    
    @Published var frame: CGImage?
    @Published var image: UIImage?
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    private let photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else { return }
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(photoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
    }
    
}


extension CameraFrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
        
    }
    
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
    
}

extension CameraFrameHandler: AVCapturePhotoCaptureDelegate {
    
    @objc func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func discardPhoto() {
        DispatchQueue.main.async { [self] in
            self.image = nil
        }
        DispatchQueue.global(qos: .background).async { [self] in
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let imageData = photo.cgImageRepresentation() else {
            return
        }
        let previewImage = UIImage(cgImage: imageData, scale: 2.0, orientation: .right)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
        DispatchQueue.main.async {
            self.frame = nil
            self.image = previewImage
        }
    }
}
