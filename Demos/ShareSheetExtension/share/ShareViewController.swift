//
//  ShareViewController.swift
//  share
//
//  Created by Lurich on 2024/1/28.
//

import UIKit
import Social
import SwiftUI
import SwiftData

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        isModalInPresentation = true
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem, let itemProviders = item.attachments {
            let hostingView = UIHostingController(rootView: ShareView(itemProviders: itemProviders, extensionContext: extensionContext))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
        
    }
}

fileprivate struct ShareView: View {
    var itemProviders: [NSItemProvider]
    var extensionContext: NSExtensionContext?
    @State private var items: [Item] = []
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            VStack(spacing: 15) {
                Text("Add To Favourites")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("Cancel", action: dismiss)
                            .tint(.red)
                    }
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(items) { item in
                            ZStack {
                                Image(uiImage: item.previewImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .blur(radius: 10)
                                
                                Image(uiImage: item.previewImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: size.width, height: 300)
                                
                            }
                            .frame(width: size.width)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 300)
                .clipShape(.rect(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.orange, lineWidth: 2.0)
                }
                
                Button(action: saveItems, label: {
                    Text("Save")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue, in: .rect(cornerRadius: 10))
                        .contentShape(.rect)
                })
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .onAppear(perform: {
                extractItems(size: size)
            })
        })
    }
    
    func extractItems(size: CGSize) {
        guard items.isEmpty else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in itemProviders {
                let _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let data, let image = UIImage(data: data), let thumbnail = image.preparingThumbnail(of: .init(width: size.width, height: 300)) {
                        DispatchQueue.main.async {
                            items.append(.init(imageData: data, previewImage: thumbnail))
                        }
                    }
                }
            }
        }
    }
    
    func saveItems() {
        do {
            let context = try ModelContext(.init(for: ImageItem.self))
            for item in items {
                context.insert(ImageItem(data: item.imageData))
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        dismiss()
    }
    
    func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
    private struct Item: Identifiable {
        let id: UUID = .init()
        var imageData: Data
        var previewImage: UIImage
    }
}
