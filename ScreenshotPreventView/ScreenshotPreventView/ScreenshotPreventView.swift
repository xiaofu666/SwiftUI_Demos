//
//  ScreenshotPreventView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/17.
//

import SwiftUI

struct ScreenshotPreventHomeView: View {
    var body: some View {
        List {
            NavigationLink("Show Image") {
                ScreenshotPreventView {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        Image(.pic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(topLeadingRadius: 55, bottomTrailingRadius: 55))
                    })
                    .padding(15)
                    .navigationTitle("Image Secure")
                }
            }
            NavigationLink("Show Security Keys") {
                List {
                    Section("API Key") {
                        ScreenshotPreventView {
                            Text("ABCDEFG")
                        }
                    }
                    Section("APNS Key") {
                        ScreenshotPreventView {
                            Text("HIJKLMN")
                        }
                    }
                }
                .navigationTitle("Key's")
            }
        }
        .navigationTitle("My List")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct ScreenshotPreventView<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    @State private var hostingViewController: UIHostingController<Content>?
    var body: some View {
        _ScreenshotPreventHelper(hostingViewController: $hostingViewController)
            .overlay {
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    
                    Color.clear
                        .preference(key: SizeKey.self, value: size)
                        .onPreferenceChange(SizeKey.self, perform: { value in
                            if let hostingViewController {
                                hostingViewController.view.frame = .init(origin: .zero, size: value)
                            } else {
                                hostingViewController = UIHostingController(rootView: content)
                                hostingViewController?.view.backgroundColor = .clear
                                hostingViewController?.view.tag = 1314
                                hostingViewController?.view.frame = .init(origin: .zero, size: size)
                            }
                        })
                })
            }
    }
}

fileprivate struct _ScreenshotPreventHelper<Content: View>: UIViewRepresentable {
    @Binding var hostingViewController: UIHostingController<Content>?
    
    func makeUIView(context: Context) -> UIView {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        if let view = textfield.subviews.first {
            return view
        }
        return UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        if let hostingViewController, !uiView.subviews.contains(where: { $0.tag == 1314 }) {
            uiView.addSubview(hostingViewController.view)
        }
    }
}

#Preview {
    NavigationStack {
        ScreenshotPreventHomeView()
    }
}
