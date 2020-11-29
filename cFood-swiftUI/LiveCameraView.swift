//
//  LiveCameraView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/26/20.
//

import SwiftUI
import UIKit
import AVKit
import Vision

struct MLData {
    static var foodName: String = "water"
    static var confidence: Float = 0.0
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    
    var foodName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveCameraViewSetup()
//        tapGesture()
    }
    
//    func tapGesture() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        view.addGestureRecognizer(tap)
//
//    }
//
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        captureSession.stopRunning()
//        liveViewRunning = false
//    }
    
   public func liveCameraViewSetup() {
       
            cameraView()
       
    }
    
    func cameraView()
    {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        view.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    // Live capture output &  MLModel reuqest
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        guard let mlmodel = try? VNCoreMLModel(for: cFoodML().model) else {return}
        
        let request = VNCoreMLRequest(model: mlmodel) { (request, err) in
            guard let results = request.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            self.foodName = String(firstObservation.identifier)
        
            
            MLData.confidence = Float(firstObservation.confidence * 100)
            
      
          
            
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }

    
    
}


struct CameraView: UIViewControllerRepresentable {
    
    @Binding var liveViewRunning: Bool
    @Binding var show: Bool
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
   
        if show {
            uiViewController.captureSession.stopRunning()
            guard uiViewController.foodName != "" else {return}
            MLData.foodName = uiViewController.foodName
            
        } else {
            uiViewController.captureSession.startRunning()
        }
    }
    
    typealias UIViewControllerType = CameraViewController
    

}
