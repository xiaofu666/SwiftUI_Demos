//
//  SpotLightTestView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/19.
//

import SwiftUI

@available(iOS 15.0, *)
struct SpotLightTestView: View {
    @State var currentTipTag = 1
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrowshape.turn.up.left")
                    .font(.title)
                    .foregroundColor(.blue)
                    .onTapGesture(perform: {
                        dismiss()
                    })
                    .spotlight(enabled: currentTipTag == 1, title: "第一个提示")
                
                Spacer()
                
                Text("提示引导")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "square.and.pencil")
                    .font(.title)
                    .foregroundColor(.blue)
                    .spotlight(enabled: currentTipTag == 2, title: "第二个提示")
            }
            .padding()
            
            Button {
                
            } label: {
                Text("按钮")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 55)
                    .background {
                        Color.blue
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            }
            .padding()
            .spotlight(enabled: currentTipTag == 3, title: "第三个提示")
            
            AsyncImage(url: URL(string: "https://img2.baidu.com/it/u=3819893115,3688664264&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1679331600&t=2c12fe5c563d8d809c5a73c408be33b1")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .spotlight(enabled: currentTipTag == 9, title: "第9个提示")


            
            Button {
                
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 55)
                    .background {
                        Color.red
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .spotlight(enabled: currentTipTag == 4, title: "第四个提示")
            
            Button {
                
            } label: {
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 55, alignment: .bottomTrailing)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        Text("图片按钮")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
            }
            .padding()
            .spotlight(enabled: currentTipTag == 5, title: "第五个提示")
            
            Spacer()
            
            AsyncImage(url: URL(string: "https://img2.baidu.com/it/u=3931597094,2206626247&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1679331600&t=5695986889dcfd7ddc86ae1c7e4c8e88")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .clipped()
            .padding()
            .spotlight(enabled: currentTipTag == 8, title: "第8个提示")

            
            Spacer()
            
            HStack {
                Label("首页", systemImage: "homekit")
                    .padding()
                    .spotlight(enabled: currentTipTag == 6, title: "第6个提示")
                
                Label("视频", systemImage: "video.circle")
                    .padding()
                    .spotlight(enabled: currentTipTag == 7, title: "第7个提示")
            }
            .labelStyle(.titleAndIcon)
        }
        .contentShape(.rect)
        .onTapGesture {
            currentTipTag += 1
            print(currentTipTag)
        }
    }
}

@available(iOS 15.0, *)
struct SpotLightTestView_Previews: PreviewProvider {
    static var previews: some View {
        SpotLightTestView()
    }
}
