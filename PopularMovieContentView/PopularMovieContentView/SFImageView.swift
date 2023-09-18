//
//  SFImageView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

@available(iOS 15.0, *)
struct SFImageView: View {
    @State private var phase: AsyncImagePhase = .empty
    @State private var isLoading: Bool = false
    private var session: URLSession = .imageSession
    private let url: URL?
    
    
    init(_ url: URL?, session: URLSession = .imageSession) {
        self.session  = session
        self.url = url
        if let url {
            let urlRequest = URLRequest(url: url)
            if let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data,
               let uiImage = UIImage(data: data) {
                _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
            } else {
                _phase = .init(wrappedValue: .empty)
            }
        }
    }
    
    var body: some View {
        Group {
            switch phase {
                case .empty:
                    ProgressView()
                        .controlSize(.large)
                        .onAppear(perform: load)
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(isLoading ? 0.5 : 1)
                        .animation(.default, value: isLoading)
                        .overlay(alignment: .topTrailing) {
                            if isLoading {
                                ProgressView()
                                    .controlSize(.large)
                                    .padding()
                            }
                        }
                        .disabled(isLoading)
                    
                case .failure:
                    Color(.systemGray6)
                        .overlay {
                            VStack {
                                Text("图片无法显示")
                                Button("重试") {
                                    phase = .empty
                                }
                            }
                        }
                    
                    
                @unknown default:
                    fatalError("This has not been implemented.")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


@available(iOS 15.0, *)
private extension SFImageView {
    func load() {
        Task {
            do {
                guard let url else { return }
                let urlRequest = URLRequest(url: url)
                let data = try await session.data(for: urlRequest)
                guard let uiImage = UIImage(data: data)  else {
                    throw URLSession.APIError.invalidData
                }
                phase = .success(.init(uiImage: uiImage))
            } catch {
                phase = .failure(error)
            }
        }
    }
}


@available(iOS 15.0, *)
struct SFImageView_Previews: PreviewProvider, View {
    @State private var isFavourited: Bool = false
    
    var body: some View {
        SFImageView(URL(string: "https://img2.baidu.com/it/u=3853345508,384760633&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1695142800&t=c9fcea8befc38be6aa2b8e8db8fd4aa2"))
    }
    
    static var previews: some View {
        Self()
    }
}
