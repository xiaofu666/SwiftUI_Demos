//
//  ContentView.swift
//  CustomUniversalAlert
//
//  Created by Lurich on 2023/9/20.
//

import SwiftUI

struct ContentView: View {
    @State private var alert: AlertConfig = .init(transitionType: .opacity)
    @State private var alert1: AlertConfig = .init(slideEdge: .trailing)
    @State private var alert2: AlertConfig = .init(enableBackgroundBlur: false, slideEdge: .top)
    @State private var alert3: AlertConfig = .init(disableOutsideTap: false, slideEdge: .leading)
    
    var body: some View {
        ZStack {
            List {
                ForEach(1...20, id: \.self) { _ in
                    Text("列表测试数据，点击显示弹框")
                        .font(.title3)
                        .padding()
                        .onTapGesture {
                            alert.present()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alert1.present()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                alert2.present()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                alert3.present()
                            }
                        }
                }
            }
            .alert(alertConfig: $alert) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue.gradient)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        alert.dismiss()
                    }
            }
            .alert(alertConfig: $alert1) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.green.gradient)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        alert1.dismiss()
                    }
            }
            .alert(alertConfig: $alert2) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.yellow.gradient)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        alert2.dismiss()
                    }
            }
            .alert(alertConfig: $alert3) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        alert3.dismiss()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
