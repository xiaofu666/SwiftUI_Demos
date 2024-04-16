//
//  ContentView.swift
//  InAppNotifications
//
//  Created by Lurich on 2023/10/9.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Show Sheet") {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet, content: {
                    Button("Show Notification") {
                        UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                            HStack {
                                Image(systemName: "wifi")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                VStack(alignment: .leading, spacing: 6, content: {
                                    Text("AirDrop")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text("From Xiaofu")
                                        .textScale(.secondary)
                                        .foregroundStyle(.gray)
                                })
                                .padding(.top, 20)
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "speaker.slash.fill")
                                        .font(.title2)
                                })
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.circle)
                                .tint(.white)
                            }
                            .padding(15)
                            .background() {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.black)
                            }
                        }
                    }
                })
                
                Button("Show Notification") {
                    UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                        HStack {
                            Image(.pic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6, content: {
                                Text("小富")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                
                                Text("这是一条通知")
                                    .textScale(.secondary)
                                    .foregroundStyle(.gray)
                            })
                            .padding(.top, 20)
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "speaker.slash.fill")
                                    .font(.title2)
                            })
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(.white)
                        }
                        .padding(15)
                        .background() {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.black)
                        }
                    }
                }
            }
            .navigationTitle("In App Notification's")
        }
    }
}

#Preview {
    ContentView()
}
