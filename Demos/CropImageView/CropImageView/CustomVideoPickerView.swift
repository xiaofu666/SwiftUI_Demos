//
//  CustomVideoPickerView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/13.
//

import SwiftUI
import PhotosUI
import AVKit

@available(iOS 16.0, *)
struct CustomVideoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var showVideoPicker: Bool = false
    @State private var isVideoProcessing: Bool = false
    @State private var pickerVideoUrl: URL?
    @State private var player: AVPlayer?
    var body: some View {
        VStack {
            ZStack {
                if let player {
                    VideoPlayer(player: player)
                }
                
                if isVideoProcessing {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            ProgressView()
                        }
                }
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Button("Picker Video") {
                showVideoPicker.toggle()
            }
            
            Button("Remove Picked Video") {
                deleteFile()
            }
            .padding(.top, 10)
        }
        .photosPicker(isPresented: $showVideoPicker, selection: $selectedItem)
        .onChange(of: selectedItem, perform: { newValue in
            if newValue != nil {
                Task {
                    do {
                        isVideoProcessing = true
                        let pickerMovie = try await newValue!.loadTransferable(type: VideoPickerTransferable.self)
                        isVideoProcessing = false
                        pickerVideoUrl = pickerMovie?.videoURL
                        if let pickerVideoUrl {
                            player = AVPlayer(url: pickerVideoUrl)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        })
        .padding()
        .onDisappear() {
            deleteFile()
        }
    }
    
    func deleteFile() {
        do {
            if pickerVideoUrl != nil {
                player?.pause()
                player?.replaceCurrentItem(with: nil)
                player = nil
                try FileManager.default.removeItem(at: self.pickerVideoUrl!)
                self.pickerVideoUrl = nil
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

@available(iOS 16.0, *)
struct CustomVideoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomVideoPickerView()
    }
}

@available(iOS 16.0, *)
struct VideoPickerTransferable: Transferable {
    var videoURL: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.videoURL)
        } importing: { receivedTransferableFile in
            let originalFile = receivedTransferableFile.file
            let copiedFile = URL.documentsDirectory.appending(path: "videoPicker.mov")
            if FileManager.default.fileExists(atPath: copiedFile.path()) {
                try FileManager.default.removeItem(at: copiedFile)
            }
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            return .init(videoURL: copiedFile)
        }

    }
}
