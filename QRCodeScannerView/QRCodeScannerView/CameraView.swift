//
//  CameraView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/10.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    var framSize: CGSize
    var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: framSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = CGRect(origin: .zero, size: framSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaData = metadataObjects.first {
            guard let readableObject = metaData as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let scanningCode = readableObject.stringValue else {
                return
            }
            print(scanningCode)
            scannedCode = scanningCode
        }
    }
}
