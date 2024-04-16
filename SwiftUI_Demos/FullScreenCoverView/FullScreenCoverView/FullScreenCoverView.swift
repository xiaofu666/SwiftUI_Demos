//
//  FullScreenCoverView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/22.
//

import SwiftUI

struct ItemColor: Hashable, Identifiable {
    var id: UUID = UUID()
    var color: Color
}

@available(iOS 16.0, *)
struct FullScreenCoverView: View {
    var items: [ItemColor] = [
        ItemColor(color: .primary),
        ItemColor(color: .secondary),
        ItemColor(color: .red),
        ItemColor(color: .orange),
        ItemColor(color: .yellow),
        ItemColor(color: .green),
        ItemColor(color: .cyan),
        ItemColor(color: .blue),
        ItemColor(color: .purple),
        ItemColor(color: .mint),
        ItemColor(color: .teal),
        ItemColor(color: .indigo),
        ItemColor(color: .pink),
        ItemColor(color: .brown),
        ItemColor(color: .gray),
        ItemColor(color: .black),
    ]
    
    @State private var show: Bool = false
    @State private var selectedItem: ItemColor = .init(color: .clear)
    @Namespace private var animation
    @State private var regularSheet: Bool = false
    @State private var lastSelectItem: ItemColor?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 5), count: 3), spacing: 5) {
                ForEach(items) { item in
                    if selectedItem.id == item.id {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 100)
                            .transition(.asymmetric(insertion: .identity, removal: .offset(x: 10, y: 10)))
                    } else {
                        Rectangle()
                            .fill(item.color)
                            .frame(height: 100)
                            .matchedGeometryEffect(id: item.id.uuidString, in: animation)
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                                    selectedItem = item
                                    lastSelectItem = item
                                    show.toggle()
                                }
                            }
                    }
                }
            }
            .padding(15)
            .overlay(alignment: .bottom) {
                Button {
                    regularSheet.toggle()
                } label: {
                    Text("Regular Screen Cover")
                }
                .offset(y: 25)
            }
        }
        .fullScreenCover(isPresented: $regularSheet) {
            Rectangle()
                .fill(lastSelectItem != nil ? lastSelectItem!.color : .red)
                .ignoresSafeArea()
                .overlay {
                    Button("Close") {
                        regularSheet.toggle()
                    }
                    .tint(.white)
                }
        }
        .heroFullScreenCover(show: $show) {
            ///detail view
            ItemColorDetailView(item: $selectedItem, animationID: animation)
        }
    }
}

@available(iOS 16.0, *)
struct FullScreenCoverView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverView()
    }
}

/// Custom view modifier extension
@available(iOS 16.0, *)
extension View {
    @ViewBuilder
    func heroFullScreenCover<Content: View>(show: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .modifier(HelperHeroView(show: show, overlay: content()))
    }
}

@available(iOS 16.0, *)
fileprivate struct HelperHeroView<Overlay: View>: ViewModifier {
    @Binding  var show: Bool
    var overlay: Overlay
    @State private var hostView: UIHostingController<Overlay>?
    @State private var parentController: UIViewController?
    
    func body(content: Content) -> some View {
        content
            .background(content: {
                ExtractSwiftUIParentController(content: overlay, hostView: $hostView) { viewController in
                    parentController = viewController
                }
            })
            .onAppear {
                hostView = UIHostingController(rootView: overlay)
            }
            .onChange(of: show) { newValue in
                if let hostView {
                    // present
                    hostView.modalPresentationStyle = .overCurrentContext
                    hostView.modalTransitionStyle = .crossDissolve
                    hostView.view.backgroundColor = .clear
                    parentController?.present(hostView, animated: false)
                } else {
                    // dismiss
                    hostView?.dismiss(animated: false)
                }
            }
    }
}

fileprivate struct ExtractSwiftUIParentController<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var hostView: UIHostingController<Content>?
    var parentController: (UIViewController?) -> ()
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        hostView?.rootView = content
        DispatchQueue.main.async {
            parentController(uiView.superview?.superview?.presentViewController)
        }
    }
}

public extension UIView {
    var presentViewController: UIViewController? {
        var responder = self.next
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}

@available(iOS 16.0, *)
struct ItemColorDetailView: View {
    @Binding var item: ItemColor
    var animationID: Namespace.ID
    @Environment(\.dismiss) private var dismiss
    @State private var animateHeroView: Bool = false
    @State private var animateContent: Bool = false
    
    var body: some View {
        VStack {
            if animateHeroView {
                Rectangle()
                    .fill(item.color.gradient)
                    .matchedGeometryEffect(id: item.id.uuidString, in: animationID)
                    .frame(width: 200, height: 200)
            } else {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 200, height: 200)
            }
            Text("Hello It's FullScreenCover ...")
                .padding(.top, 10)
                .opacity(animateContent ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.white
                .ignoresSafeArea()
                .opacity(animateContent ? 1 : 0)
        }
        .overlay(alignment: .topLeading) {
            Button {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animateContent = false
                    animateHeroView = false
                    item = .init(color: .clear)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(item.color)
            }
            .padding(15)
            .opacity(animateContent ? 1 : 0)

        }
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                animateHeroView = true
                animateContent = true
            }
        }
    }
}
