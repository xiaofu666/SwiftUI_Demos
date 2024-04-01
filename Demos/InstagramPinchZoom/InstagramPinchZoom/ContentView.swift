//
//  ContentView.swift
//  InstagramPinchZoom
//
//  Created by Lurich on 2024/3/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(posts){
                            CardView($0)
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Instagram")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
    @ViewBuilder
    func CardView(_ post: Post) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader {
                let size = $0.size
                Image(post.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 10))
                    .pinchZoom()
            }
            .frame(height:240)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading,spacing: 2) {
                    Text(post.title)
                        .font(.callout)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("By " + post.author)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 0)
                
                if let link = URL(string: post.url) {
                    Link("Visit",destination: link)
                        .font(.caption)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    ContentView()
}
