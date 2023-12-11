//
//  RecordExtension.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/19.
//

import SwiftUI
import ReplayKit

extension View {
    func startRecording(enableMicorphone: Bool = false, completion: @escaping (Error?) -> ()) {
        let record = RPScreenRecorder.shared()
        record.isMicrophoneEnabled = enableMicorphone
        record.startRecording(handler: completion)
    }
    
    func stopRecording() async throws -> URL {
        let name = UUID().uuidString + ".mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        let record = RPScreenRecorder.shared()
        try await record.stopRecording(withOutput: url)
        return url
    }
    
    func cancelRecording() {
        let record = RPScreenRecorder.shared()
        record.discardRecording {
            print("取消录屏")
        }
    }
    
    func shareSheet(show: Binding<Bool>, items: [Any?]) -> some View {
        return self.sheet(isPresented: show) {
            let items = items.compactMap { item -> Any? in
                return item
            }
            if !items.isEmpty {
                ActivitySheet(items: items)
            }
        }
    }
}

