//
//  CustomImagePicker.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/12.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
extension View {
    func cropImagePicker(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    func haptice(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

@available(iOS 16.0, *)
fileprivate struct CustomImagePicker<Content: View>: View {
    var options: [Crop]
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    var content: Content
    
    init(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>, content: @escaping () -> Content) {
        self.options = options
        self._show = show
        self._croppedImage = croppedImage
        self.content = content()
    }
    
    @State var photosItem: PhotosPickerItem?
    @State var selectedImage: UIImage?
    @State var showDialog: Bool = false
    @State var selectedCropType: Crop = .circle
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { newValue in
                if let value = newValue {
                    Task {
                        if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            await MainActor.run(body: {
                                selectedImage = image
                                showDialog.toggle()
                            })
                        }
                    }
                }
            }
            .confirmationDialog("", isPresented: $showDialog) {
                ForEach(options.indices, id: \.self) { index in
                    Button(options[index].name()) {
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
                selectedImage = nil
            } content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

@available(iOS 16.0, *)
struct CropView: View {
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    
    @Environment(\.dismiss) var dismiss
    
    //MARK: 图片操作相关
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack {
            imageView()
                .navigationTitle("Crop Image")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            let renderer = ImageRenderer(content: imageView(true))
                            renderer.proposedSize = .init(crop.size())
                            if let uiimage = renderer.uiImage {
                                onCrop(uiimage, true)
                            } else {
                                onCrop(nil, false)
                            }
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                        }

                    }
                }
        }
    }
    
    @ViewBuilder
    func imageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if rect.minX > 0 {
                                            offset.width -= rect.minX
                                            haptice(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.height -= rect.minY
                                            haptice(.medium)
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = rect.minX - offset.width
                                            haptice(.medium)
                                        }
                                        if rect.maxY < size.height {
                                            offset.height = rect.minY - offset.height
                                            haptice(.medium)
                                        }
                                    }
                                    if !newValue {
                                        lastOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(width: size.width, height: size.height)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay(content: {
            if !hideGrids {
                Grids()
            }
        })
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, state, _ in
                    state = true
                })
                .onChanged({ value in
                    offset = CGSize(width: value.translation.width + lastOffset.width, height: value.translation.height + lastOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, state, _ in
                    state = true
                })
                .onChanged({ value in
                    let updatedScale = lastScale + value
                    scale = updatedScale < 1 ? 1 : updatedScale
                })
                .onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(width: cropSize.width, height: cropSize.height)
        .cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
    }
    
    @ViewBuilder
    func Grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...(Int(crop.size().width) / 60), id: \.self) { index in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            VStack {
                ForEach(1...(Int(crop.size().height) / 60), id: \.self) { index in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct CustomImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        CropView(crop: .rectangle, image: UIImage(named: "Pic")) { _, _ in
            
        }
    }
}
