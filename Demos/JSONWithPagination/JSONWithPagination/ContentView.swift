//
//  ContentView.swift
//  JSONWithPagination
//
//  Created by Lurich on 2024/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @State private var photos: [PhotosModel] = []
    @State private var page: Int = 1
    @State private var lastFetchedPage: Int = 1
    @State private var isLoading: Bool = false
    @State private var activePhotoID: String?
    @State private var lastPhotoID: String?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                    ForEach(photos) { photo in
                        PhotoCardView(photo: photo)
                    }
                }
                .overlay(alignment: .bottom, content: {
                    ProgressView()
                        .offset(y: 30)
                })
                .padding(15)
                .padding(.bottom, 15)
                .scrollTargetLayout()
            }
            .scrollPosition(id: $activePhotoID, anchor: .bottomTrailing)
            .onChange(of: activePhotoID, { oldValue, newValue in
                if newValue == lastPhotoID, !isLoading {
                    page += 1
                    fetchPhotos()
                }
            })
            .navigationTitle("JSON Parsing")
            .onAppear() {
                if photos.isEmpty {
                    fetchPhotos()
                }
            }
        }
    }
    
    func fetchPhotos() {
        Task {
            do {
                if let requestURL = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") {
                    isLoading = true
                    let session = URLSession(configuration: .default)
                    let jsonData = try await session.data(from: requestURL).0
                    let photos = try JSONDecoder().decode([PhotosModel].self, from: jsonData)
                    await MainActor.run {
                        if photos.isEmpty {
                            page = lastFetchedPage
                        } else {
                            self.photos.append(contentsOf: photos)
                            lastPhotoID = self.photos.last?.id
                            lastFetchedPage = page
                        }
                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}

struct PhotoCardView: View {
    let photo: PhotosModel
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                AnimatedImage(url: photo.imageURL) {
                    ProgressView()
                        .font(.title3)
                        .frame(width: size.width, height: size.height)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 10))
            })
            .frame(height: 120)
            
            Text(photo.author)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(1)
        })
    }
}

#Preview {
    ContentView()
}
