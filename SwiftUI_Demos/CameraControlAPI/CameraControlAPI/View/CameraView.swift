//
//  CameraView.swift
//  CameraControlAPI
//
//  Created by Xiaofu666 on 2024/10/19.
//

import SwiftUI
import AVKit

enum CameraPermission: String, CaseIterable {
    case granted = "Permission Granted"
    case idle = "Not Decided"
    case denied = "Permission Denied"
}

@MainActor
@Observable
class Camera: NSObject {

    private let queue: DispatchSerialQueue = .init(label: "dev.xiaofu666.CameraControlAPI.SessionQueue")
    let session: AVCaptureSession = .init()
    var cameraPosition: AVCaptureDevice.Position = .back
    let cameraOutPut: AVCapturePhotoOutput = .init()
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    var permission: CameraPermission = .idle
    
    override init() {
        super.init()
        checkCameraPermission()
    }
    
    private func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                permission = .granted
                setupCamera()
            case .notDetermined:
                permission = .denied
                if await AVCaptureDevice.requestAccess(for: .video) {
                    setupCamera()
                }
            case .denied, .restricted:
                permission = .denied
            @unknown default: break
            }
        }
    }
    
    private func setupCamera() {
        do {
            session.beginConfiguration()
            
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: cameraPosition).devices.first else {
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(cameraOutPut) else {
                session.commitConfiguration()
                return
            }
            session.addInput(input)
            session.addOutput(cameraOutPut)
            setupCameraControl(device)
            session.commitConfiguration()
            startSession()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startSession() {
        guard !session.isRunning else { return }
        Task.detached(priority: .background) {
            await self.session.startRunning()
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        Task.detached(priority: .background) {
            await self.session.stopRunning()
        }
    }
    
    private func setupCameraControl(_ device: AVCaptureDevice) {
        guard session.supportsControls else { return }
        session.setControlsDelegate(self, queue: queue)
        for control in session.controls {
            session.removeControl(control)
        }
        
        // 方案一：系统默认的控制
//        let zoomControl = AVCaptureSystemZoomSlider(device: device) { zoomProgress in
//            print(zoomProgress)
//        }
//        if session.canAddControl(zoomControl) {
//            session.addControl(zoomControl)
//        } else {
//            print("Control can't be added")
//        }
        
        // 方案二：自定义控制
        let zoomControl = AVCaptureSlider("Zoom", symbolName: "plus.magnifyingglass", in: -0.5...0.5)
        zoomControl.setActionQueue(queue) { progress in
            print(progress)
        }
        let filters: [String] = ["None", "B/W", "Vivid", "Comic", "Humid"]
        let filterControl = AVCaptureIndexPicker("Filters", symbolName: "camera", localizedIndexTitles: filters)
        filterControl.setActionQueue(queue) { index in
            print("Selected Filter: ", filters[index])
        }
        let controls: [AVCaptureControl] = [zoomControl, filterControl]
        for control in controls {
            if session.canAddControl(control) {
                session.addControl(control)
            } else {
                print("Control can't be added")
            }
        }
    }
    
    func capturePhoto() {
        print("Capture photo")
    }
}

extension Camera: AVCaptureSessionControlsDelegate {
    
    nonisolated func sessionControlsDidBecomeActive(_ session: AVCaptureSession) {
        
    }
    
    nonisolated func sessionControlsWillEnterFullscreenAppearance(_ session: AVCaptureSession) {
        
    }
    
    nonisolated func sessionControlsWillExitFullscreenAppearance(_ session: AVCaptureSession) {
        
    }
    
    nonisolated func sessionControlsDidBecomeInactive(_ session: AVCaptureSession) {
        
    }
    
}

struct CameraView: View {
    var camera: Camera = .init()
    @Environment(\.scenePhase) private var scene
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            CameraLayerView(size: size)
        }
        .environment(camera)
        .onChange(of: scene) { oldValue, newValue in
            if newValue == .active {
                camera.startSession()
            } else {
                camera.stopSession()
            }
        }
    }
}

struct CameraLayerView: UIViewRepresentable {
    var size: CGSize
    @Environment(Camera.self) private var camera
    
    func makeUIView(context: Context) -> some UIView {
        let frame = CGRect(origin: .zero, size: size)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        let layer = AVCaptureVideoPreviewLayer(session: camera.session)
        layer.videoGravity = camera.videoGravity
        layer.frame = frame
        layer.masksToBounds = true
        view.layer.addSublayer(layer)
        setupCameraInteraction(view)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func setupCameraInteraction(_ view: UIView) {
        let cameraInteraction = AVCaptureEventInteraction { event in
            if event.phase == .ended {
                camera.capturePhoto()
            }
        }
        view.addInteraction(cameraInteraction)
    }
}

#Preview {
    CameraView()
}
