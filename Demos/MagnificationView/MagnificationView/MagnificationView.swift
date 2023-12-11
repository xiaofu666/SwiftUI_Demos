//
//  MagnificationView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/6.
//

import SwiftUI

@available(iOS 15.0, *)
struct MagnificationView: View {
    @State private var scale: CGFloat = 0
    @State private var rotation: CGFloat = 0
    @State private var size: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader {
                let size = $0.size
                
                Image("iphoneBg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                    .magnificationEffect(scale, rotation, self.size, .gray)
            }
            .padding(50)
            .contentShape(Rectangle())
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Costomizations")
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.bottom, 20)
                
                HStack {
                    Text("Scale")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35)
                    
                    Slider(value: $scale)
                    
                    Text("Rotation")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Slider(value: $rotation)
                }
                .tint(.black)
                
                HStack {
                    Text("Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35)
                    
                    Slider(value: $size, in: -20...100)
                }
                .tint(.black)
                .padding(.top, 15)
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.black.opacity(0.08).ignoresSafeArea()
        }
    }
}

@available(iOS 15.0, *)
struct MagnificationView_Previews: PreviewProvider {
    static var previews: some View {
        MagnificationView()
    }
}
