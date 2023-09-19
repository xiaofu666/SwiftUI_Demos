//
//  QRCodeScannerView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/10.
//

import SwiftUI
import AVKit

@available(iOS 15.0, *)
struct QRCodeScannerView: View {
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMessage: String = ""
    @State private var isShowError: Bool = false
    @State private var cameraPermission: Permission = .idle
    @State private var scannedCode: String = ""
    
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 8) {

            Text("Place the QR Code inside the area")
                .font(.title3)
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.top, 10)
            
            Spacer(minLength: 0)
            
            // 扫码区域
            GeometryReader {
                let size = $0.size
                ZStack {
                    CameraView(framSize: CGSize(width: size.width, height: size.width), session: session)
                        .scaleEffect(0.98)
                    
                    ForEach(1...4, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(Double(index * 90)))
                    }
                }
                .frame(width: size.width, height: size.width)
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: 2.5)
                        .shadow(color: .blue.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Text(scannedCode)
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.top, 10)
                .onTapGesture {
                    UIPasteboard.general.string = scannedCode
                    scannedCode = "已复制到粘贴板"
                }
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reactivateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Spacer(minLength: 45)
        }
        .padding()
        .onAppear(perform: checkCameraPermission)
        .alert(errorMessage, isPresented: $isShowError) {
            if cameraPermission == .denied {
                Button("Setting") {
                    let url = UIApplication.openSettingsURLString
                    if let settingUrl = URL(string: url) {
                        openURL(settingUrl)
                    }
                }
                
                Button("Cannel", role: .cancel) {
                    
                }
            }
        }
        .onChange(of: qrDelegate.scannedCode) { newValue in
            if let value = newValue {
                scannedCode = value
                session.stopRunning()
                deActivateScannerAnimation()
                qrDelegate.scannedCode = nil
            }
        }
    }
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    func deActivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.35)) {
            isScanning = false
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    session.startRunning()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to camera for scanning codes")
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNDNOWN INPUT/OUTPUT ERROR")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        isShowError.toggle()
    }
}

@available(iOS 15.0, *)
struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerView()
    }
}

fileprivate enum Permission: String {
    case idle = "Not Datermined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}
