//
//  SearchNavView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/11.
//

import SwiftUI

@available(iOS 16.0, *)
struct SearchNavView: View {
    @State private var offsetY = 0.0
    @State private var showSearchBar = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { proxy in
            let safeAreaTop = proxy.safeAreaInsets.top
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView(safeAreaTop)
                        .offset(y: -offsetY)
                        .zIndex(1)
                    
                    ForEach(1...11, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .fill(.blue.gradient)
                            .frame(height: 220)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                }
                .getMinY(coordinateSpace: .named("SearchNavView")) { offset in
                    offsetY = offset
                    showSearchBar = (-offset > 80) && showSearchBar
                }
                .zIndex(0)
            }
            .coordinateSpace(name: "SearchNavView")
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat) -> some View {
        let progress = -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    
                    TextField("Search", text: .constant(""))
                        .tint(.red)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.black)
                        .opacity(0.15)
                }
                .opacity(showSearchBar ? 1 : 1 + progress)
                
                Button {
                    dismiss()
                } label: {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                }
                .opacity(showSearchBar ? 0 : 1)
                .overlay {
                    if showSearchBar {
                        Button {
                            showSearchBar = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }

                    }
                }
            }
            
            HStack(spacing: 0) {
                CustomButton(symbolImage: "rectangle.portrait.and.arrow.forward", title: "Deposit") {
                    print("Deposit click")
                }
                
                CustomButton(symbolImage: "dollarsign", title: "Withraw") {
                    print("Withraw click")
                }
            
                CustomButton(symbolImage: "qrcode", title: "QR Code") {
                    print("QR Code click")
                }
            
                CustomButton(symbolImage: "qrcode.viewfinder", title: "Scanning") {
                    print("Scanning click")
                }
            }
            .padding(.horizontal, -progress * 50)
            .padding(.top, 10)
            .offset(y: progress * 65)
            .opacity(showSearchBar ? 0 : 1)
        }
        .overlay(alignment: .topLeading, content: {
            Button {
                showSearchBar = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .offset(x: 13, y: 10)
            .opacity(showSearchBar ? 0 : -progress)
        })
        .animation(.easeInOut(duration: 0.25), value: showSearchBar)
        .environment(\.colorScheme, .dark)
        .padding([.horizontal, .vertical], 15)
        .padding(.top, safeAreaTop + 10)
        .background {
            Rectangle()
                .fill(.red.gradient)
                .padding(.bottom, -progress * 85)
        }
    }
    
    @ViewBuilder
    func CustomButton(symbolImage: String, title: String, onClick: @escaping () -> ()) -> some View {
        let progress = -(offsetY / 40) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 40))
        Button {
            onClick()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: symbolImage)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(width: 35, height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .opacity(1 + progress)
            .overlay {
                Image(systemName: symbolImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(-progress)
                    .offset(y: -10)
            }
        }
    }
}

@available(iOS 16.0, *)
struct SearchNavView_Previews: PreviewProvider {
    static var previews: some View {
        SearchNavView()
    }
}
