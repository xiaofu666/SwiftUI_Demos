//
//  iOSControlCenterAnimation.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/5/13.
//

import SwiftUI

@available(iOS 16.0, *)
struct iOSControlCenterAnimation: View {
    var body: some View {
        GeometryReader { proxy in
            ControlCenterAnimationView(safeArea: proxy.safeAreaInsets, size: proxy.size)
                .ignoresSafeArea(.container, edges: .all)
        }
    }
}

@available(iOS 16.0, *)
struct iOSControlCenterAnimation_Previews: PreviewProvider {
    static var previews: some View {
        iOSControlCenterAnimation()
    }
}


@available(iOS 16.0, *)
private struct ControlCenterAnimationView: View {
    var safeArea: EdgeInsets
    var size: CGSize
    
    @State private var volumeConfig: SliderConfig = .init()
    @State private var brightnessConfig: SliderConfig = .init()
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            if size.width >= 50 {
                let paddedWidth = size.width - 50
                
                Image("iphoneBg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width)
                    .blur(radius: 45, opaque: true)
                    .clipped()
                    .onTapGesture(perform: resetConfig)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                    ActionView()
                        .frame(height: paddedWidth * 0.5)
                        .background {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.thinMaterial)
                                .reverseMask {
                                    ActionView(true)
                                }
                        }
                        .hiddenView(([volumeConfig, brightnessConfig]))
                    
                    AudioControls()
                        .frame(height: paddedWidth * 0.5)
                        .hiddenView(([volumeConfig, brightnessConfig]))
                    
                    OtherControls()
                        .frame(height: paddedWidth * 0.5)
                        .hiddenView(([volumeConfig, brightnessConfig]))
                    
                    InteractiveControls()
                        .frame(height: paddedWidth * 0.5)
                        .hiddenView(([volumeConfig, brightnessConfig]))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 15)
                .padding(.vertical, 25)
                .padding(.top, safeArea.top)
                .overlay(content: {
                    ExpandedVolumeControl(paddedWidth)
                        .overlay(alignment: .top) {
                            ZStack {
                                if volumeConfig.animateContent {
                                    Image(systemName: "speaker.wave.3.fill", variableValue: volumeConfig.progress)
                                        .font(.title)
                                        .offset(y: -110)
                                        .transition(.opacity)
                                }
                            }
                            .animation(.easeInOut(duration: 0.2), value: volumeConfig.animateContent)
                        }
                    
                    ExpandedBrightnessControl(paddedWidth)
                        .overlay(alignment: .top) {
                            ZStack {
                                if brightnessConfig.animateContent {
                                    Image(systemName: "sun.max.fill")
                                        .font(.title)
                                        .offset(y: -110)
                                        .transition(.opacity)
                                }
                            }
                            .animation(.easeInOut(duration: 0.2), value: volumeConfig.animateContent)
                        }
                })
                .animation(.easeInOut(duration: 0.2), value: volumeConfig.expand)
                .animation(.easeInOut(duration: 0.2), value: brightnessConfig.expand)
                .environment(\.colorScheme, .dark)
            }
        }
    }
    
    @ViewBuilder
    func ActionView(_ mask: Bool = false) -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                ButtonView("airplane", mask)
                ButtonView("antenna.radiowaves.left.and.right", mask)
            }
            
            HStack(spacing: 15) {
                ButtonView("wifi", mask)
                ButtonView("personalhotspot", mask)
            }
        }
        .padding(13)
    }
    
    @ViewBuilder
    func ButtonView(_ image: String, _ mask: Bool) -> some View {
        Image(systemName: image)
            .font(.title2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if mask {
                    Circle()
                }
            }
    }
    
    @ViewBuilder
    func AudioControls() -> some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "backward.fill")
                    .foregroundColor(.gray)
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                Image(systemName: "forward.fill")
                    .foregroundColor(.gray)
            }
            .font(.title3)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .addRoundedBG()
    }
    
    @ViewBuilder
    func OtherControls() -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                Image(systemName: "lock.open.rotation")
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .addRoundedBG()
                
                Image(systemName: "rectangle.on.rectangle")
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .addRoundedBG()
                
            }
            
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .frame(width: 50, height: 50)
                
                Text("专注模式")
                    .fontWeight(.medium)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background {
                Color.clear
                    .addRoundedBG()
                    .reverseMask {
                        Circle()
                            .frame(width: 50, height: 50)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                    }
            }
        }
    }
    
    @ViewBuilder
    func InteractiveControls() -> some View {
        HStack(spacing: 15) {
            CustomSlider(
                thumbImage: "sun.max.fill",
                animationID: "EXPAND_BRIGHTNESS",
                namespaceID: namespace,
                show: !brightnessConfig.expand,
                config: $brightnessConfig
            )
            .opacity(brightnessConfig.showContent ? 0 : 1)
            
            CustomSlider(
                thumbImage: "speaker.wave.3.fill",
                animationID: "EXPAND_VOLUME",
                namespaceID: namespace,
                show: !volumeConfig.expand,
                config: $volumeConfig
            )
            .opacity(volumeConfig.showContent ? 0 : 1)
        }
    }
    
    @ViewBuilder
    func ExpandedBrightnessControl(_ width: CGFloat) -> some View {
        if brightnessConfig.expand {
            VStack {
                CustomSlider(
                    thumbImage: "sun.max.fill",
                    animationID: "EXPAND_BRIGHTNESS",
                    cornerRadius: 30,
                    namespaceID: namespace,
                    show: brightnessConfig.expand,
                    config: $brightnessConfig
                )
                .opacity(brightnessConfig.showContent ? 1 : 0)
                .frame(width: width * 0.35, height: width)
            }
            .transition(.offset(x: 1, y: 1))
            .onAppear() {
                brightnessConfig.showContent = true
                brightnessConfig.animateContent = true
            }
        }
    }
    
    @ViewBuilder
    func ExpandedVolumeControl(_ width: CGFloat) -> some View {
        if volumeConfig.expand {
            VStack {
                CustomSlider(
                    thumbImage: "speaker.wave.3.fill",
                    animationID: "EXPAND_VOLUME",
                    cornerRadius: 30,
                    namespaceID: namespace,
                    show: volumeConfig.expand,
                    config: $volumeConfig
                )
                .opacity(volumeConfig.showContent ? 1 : 0)
                .frame(width: width * 0.35, height: width)
            }
            .transition(.offset(x: 1, y: 1))
            .onAppear() {
                volumeConfig.showContent = true
                volumeConfig.animateContent = true
            }
        }
    }
    
    func resetConfig() {
        volumeConfig.expand = false
        brightnessConfig.expand = false
        
        volumeConfig.animateContent = false
        brightnessConfig.animateContent = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            volumeConfig.showContent = false
            brightnessConfig.showContent = false
        }
    }
}

@available(iOS 16.0, *)
private struct CustomSlider: View {
    var thumbImage: String
    var animationID: String
    var cornerRadius: CGFloat = 18
    var namespaceID: Namespace.ID
    var show: Bool
    @Binding var config: SliderConfig
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                if show {
                    Rectangle()
                        .fill(.thinMaterial)
                        .overlay {
                            Rectangle()
                                .fill(.white)
                                .scaleEffect(y: config.progress, anchor: .bottom)
                        }
                        .overlay(alignment: .bottom) {
                            Image(systemName: thumbImage, variableValue: config.progress)
                                .font(.title)
                                .blendMode(.exclusion)
                                .padding(.bottom, 20)
                                .foregroundColor(.gray)
                                .opacity(config.animateContent && show ? 0 : 1)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: config.animateContent ? cornerRadius : 18, style: .continuous))
                        .animation(.easeInOut(duration: 0.2), value: config.animateContent)
                        .scaleEffect(config.shrink ? 0.95 : 1)
                        .animation(.easeInOut(duration: 0.25), value: config.shrink)
                        .matchedGeometryEffect(id: animationID, in: namespaceID)
                }
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .onEnded({ _ in
                        expandView()
                    })
                    .simultaneously(with: DragGesture().onChanged({ value in
                        if !config.shrink {
                            let startLocation = value.startLocation.y
                            let currentLocation = value.location.y
                            let offset = startLocation - currentLocation
                            var progress = (offset / size.height) + config.lastProgress
                            progress = max(min(progress, 1), 0)
                            config.progress = progress
                        }
                    }).onEnded({ value in
                        config.lastProgress = config.progress
                    }))
            )
        }
    }
    
    func expandView() {
        config.shrink = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            config.shrink = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                config.expand = true
            }
        }
    }
}
private struct SliderConfig {
    var shrink: Bool = false
    var expand: Bool = false
    var showContent: Bool = false
    var animateContent: Bool = false
    var progress: CGFloat = 0
    var lastProgress: CGFloat = 0
}

private extension View {
    @ViewBuilder
    func hiddenView(_ configs: [SliderConfig]) -> some View {
        let status = configs.contains(where: { $0.expand })
        self
            .opacity(status ? 0 : 1)
            .animation(.easeInOut(duration: 0.2), value: status)
    }
    
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
    
    @ViewBuilder
    func addRoundedBG() -> some View {
        self
            .background {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.thinMaterial)
            }
    }
}
