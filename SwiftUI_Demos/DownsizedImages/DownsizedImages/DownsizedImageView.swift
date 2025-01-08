//
//  DownsizedImageView.swift
//  DownsizedImages
//
//  Created by Xiaofu666 on 2025/1/7.
//

import SwiftUI

struct DownsizedImageView<Content: View>: View {
    var id: String
    var image: UIImage?
    var size: CGSize
    @ViewBuilder var content: (Image) -> Content
    
    @State private var downsizedImage: Image?
    
    var body: some View {
        ZStack {
            if let downsizedImage {
                content(downsizedImage)
            }
        }
        .onAppear {
            guard downsizedImage == nil else { return }
            createDownsizedImage(image)
        }
        .onChange(of: image) { oldValue, newValue in
            guard oldValue != newValue else { return }
            createDownsizedImage(newValue)
        }
    }
    
    private func createDownsizedImage(_ image: UIImage?) {
        if let cacheData = try? CacheManager.shared.get(id: id)?.data, let uiImage = UIImage(data: cacheData) {
            print("From Cache")
            downsizedImage = .init(uiImage: uiImage)
        } else {
            print("Downsizing")
            guard let image else { return }
            let aspectSize = image.size.aspectFit(size)
            Task.detached(priority: .high) {
                let render = UIGraphicsImageRenderer(size: aspectSize)
                let resizedImage = render.image { ctx in
                    image.draw(in: .init(origin: .zero, size: aspectSize))
                }
                if let jpegData = resizedImage.jpegData(compressionQuality: 1) {
                    await MainActor.run {
                        try? CacheManager.shared.insert(id: id, data: jpegData, expirationDays: 1)
                    }
                }
                await MainActor.run {
                    downsizedImage = .init(uiImage: resizedImage)
                }
            }
        }
    }
}

extension CGSize {
    func aspectFit(_ to: CGSize) -> CGSize {
        let scaleX = to.width / self.width
        let scaleY = to.height / self.height
        
        let aspectRatio = min(scaleX, scaleY)
        return .init(width: aspectRatio * width, height: aspectRatio * height)
    }
}


#Preview {
    ContentView()
}
