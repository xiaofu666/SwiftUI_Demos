//
//  DragImagePickerView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/8/26.
//

import SwiftUI
import PhotosUI

struct DragImagePickerView: View {
    var body: some View {
        VStack {
            ImagePicker(title: "Drag & Drop", subTitle: "Tap to add an Image", systemImage: "square.and.arrow.up", tint: .blue) { image in
                
            }
            .frame(maxWidth: 300, maxHeight: 250)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Image Picker")
    }
}

#Preview {
    NavigationStack {
        DragImagePickerView()
    }
}

struct ImagePicker: View {
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChange: (UIImage) -> ()
    
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var previewImage: UIImage?
    @State private var isLoading: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            VStack(spacing: 4, content: {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(tint)
                
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            })
            .opacity(previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay(content: {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                }
            })
            .overlay(content: {
                if isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            })
            .animation(.snappy, value: isLoading)
            .animation(.snappy, value: previewImage)
            .contentShape(.rect)
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    generateImageThumbnail(droppedImage, size)
                    onImageChange(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
            .onTapGesture {
                showImagePicker.toggle()
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem.self, { oldValue, newValue in
                if let newValue {
                    extractImage(newValue, size)
                }
            })
            .background() {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
            }
        })
    }
    
    func extractImage(_ photoItem: PhotosPickerItem, _ size: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else { return }
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    generateImageThumbnail(selectedImage, size)
                    onImageChange(selectedImage)
                }
                self.photoItem = nil
            }
        }
    }
    
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            await MainActor.run {
                previewImage = thumbnailImage
            }
        }
    }
}
