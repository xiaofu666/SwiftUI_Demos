//
//  CropImageView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/12.
//

import SwiftUI

@available(iOS 16.0, *)
struct CropImageView: View {
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        VStack {
            if let croppedImage {
                Image(uiImage: croppedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 400)
            } else {
                Text("No Image is Selected")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Crop Image Picker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                }
                .tint(.black)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    CustomVideoPickerView()
                } label: {
                    Image(systemName: "video.bubble.left")
                        .tint(.black)
                }

            }
        }
        .cropImagePicker(options: [.circle, .rectangle, .square, .custom(CGSize(width: 400, height: 300))], show: $showPicker, croppedImage: $croppedImage)
    }
}

@available(iOS 16.0, *)
struct CropImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CropImageView()
        }
    }
}


enum Crop: Equatable {
    case circle
    case rectangle
    case square
    case custom(CGSize)
    
    func name() -> String {
        switch self {
        case .circle:
            return "Circle"
        case .rectangle:
            return "rectangle"
        case .square:
            return "Square"
        case .custom(let size):
            return "Custom \(Int(size.width))X\(Int(size.height))"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle:
            return .init(width: 300, height: 300)
        case .rectangle:
            return .init(width: 300, height: 500)
        case .square:
            return .init(width: 300, height: 300)
        case .custom(let size):
            return size
        }
    }
}
