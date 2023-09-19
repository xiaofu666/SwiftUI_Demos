//
//  RecordVideoView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/19.
//

import SwiftUI

@available(iOS 16.0, *)
struct RecordVideoView: View {
    @State var objectCount = 1
    @State var isRecording = false
    @State var url: URL?
    @State var shareVideo = false
    @State var cgImage: CGImage?
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            AdaptiveView {
                VStack(spacing: 10) {
                    ForEach (1...objectCount, id: \.self) { index in
                        if let cgimage = self.cgImage {
                            Image(cgimage, scale: 1.1, label: Text("Image Render"))
                        } else {
                            EmptyView()
                        }
                    }
                }
                .padding(15)
                .onTapGesture {
                    objectCount += 1
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    if isRecording {
                        Task {
                            do {
                                self.url = try await stopRecording()
                                isRecording = false
                                shareVideo.toggle()
                                print(self.url ?? "录屏失败")
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        startRecording { error in
                            if let error = error {
                                print(error)
                                return
                            }
                            isRecording = true
                        }
                    }
                } label: {
                    Image(systemName: isRecording ? "record.circle.fill" : "record.circle")
                        .font(.largeTitle)
                        .foregroundColor(isRecording ? .red : .white)
                }
                .padding(20)
            }
            .shareSheet(show: $shareVideo, items: [url])
            .onAppear {
                let imageRender = ImageRenderer(content: createView())
                imageRender.scale = 0.95
                imageRender.isOpaque = true
                if let cgimage = imageRender.cgImage {
                    self.cgImage = cgimage
                }
            }
        }
    }
    
    @ViewBuilder
    func createView() -> some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .frame(width: UIScreen.main.bounds.size.width, height: 150)
            
            HStack {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.largeTitle)
                    .shadow(color: .black, radius: 8, x: 5, y: 5)
                    .padding(20)
                
                VStack(alignment: .leading) {
                    Text("gril")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("weight: 45kg")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                    
                    Text("height: 165cm")
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
}

@available(iOS 16.0, *)
struct RecordVideoView_Previews: PreviewProvider {
    static var previews: some View {
        RecordVideoView()
    }
}

@available(iOS 16.0, *)
struct AdaptiveView<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ViewThatFits {
            content
            
            ScrollView {
                content
            }
        }
    }
}
