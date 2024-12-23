//
//  ContentView.swift
//  ImageSliderView
//
//  Created by Xiaofu666 on 2024/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 35) {
                    CellView()
                    
                    CellView()
                }
            }
            .safeAreaPadding(15)
            .navigationTitle("Image Viewer")
        }
    }
}

struct CellView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(.pic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(.circle)
            
            VStack {
                Text("这是一个示例文案，因为要形容文字很长，所以这里要模拟很多字，至少显示三行看起来正常一些。")
                
                ImageViewer(config: .init()) {
                    ForEach(sampleImages) { model in
                        AsyncImage(url: URL(string: model.link)) { image in
                            image
                                .resizable()
                                .overlay(alignment: .center) {
                                    Text(model.altText)
                                        .foregroundStyle(.white)
                                        .offset(y: -340)
                                }
                        } placeholder: {
                            Rectangle()
                                .fill(.gray.opacity(0.4))
                                .overlay {
                                    ProgressView()
                                        .tint(.blue)
                                        .scaleEffect(0.7)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                        }
                        .containerValue(\.activeViewID, model.id)
                    }
                } overlay: {
                    OverlayView()
                } updates: { isPresented, activeViewID in
                    if let activeViewID {
                        print(isPresented, activeViewID)
                    }
                }
            }
        }
    }
}

struct OverlayView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(10)
                    .contentShape(.circle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .padding(15)
    }
}

#Preview {
    ContentView()
}
