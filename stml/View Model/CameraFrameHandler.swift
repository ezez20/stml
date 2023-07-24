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
    
    private let videoOutput = AVCaptureVideoDataOutput()
    private let photoOutput = AVCapturePhotoOutput()
    private var cameraPositonFront = true

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
    
    func flipCamera() {
        print("flipCamera")
        cameraPositonFront.toggle()
        guard permissionGranted else { return }
        guard let currentVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: cameraPositonFront ? .front : .back) else { return }
        guard let currentDeviceInput = try? AVCaptureDeviceInput(device: currentVideoDevice) else { return }
        for input in captureSession.inputs {
            print("Removing input: \(input)")
            captureSession.removeInput(input)
            captureSession.removeOutput(videoOutput)
            captureSession.removeOutput(photoOutput)
        }
        
        guard let newVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: cameraPositonFront ? .back : .front) else { return }
        guard let newDeviceInput = try? AVCaptureDeviceInput(device: newVideoDevice) else { return }
        guard captureSession.canAddInput(newDeviceInput) else { return }
        captureSession.addInput(newDeviceInput)
        
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
        let ciImage = CIImage(cvPixelBuffer: imageBuffer).oriented(cameraPositonFront ? .up : .upMirrored)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        return cgImage
    }
    
}

extension CameraFrameHandler: AVCapturePhotoCaptureDelegate {
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func discardPhoto() {
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
    
        DispatchQueue.main.async { [self] in
            self.image = nil
        }

        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation() else { return }
        print("didFinishProcessingPhoto")
        guard let imageData = photo.cgImageRepresentation() else {
            return
        }
        let previewImage = UIImage(cgImage: imageData, scale: 2.0, orientation: cameraPositonFront ? .right : .leftMirrored)
        
        DispatchQueue.global(qos: .background).async { [self] in
            DispatchQueue.main.async {
//                self.frame = nil
                self.image = previewImage
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("didCapturePhotoFor")
        captureSession.removeOutput(videoOutput)
        DispatchQueue.main.async {
            self.frame = nil
        }
    }
    
}
