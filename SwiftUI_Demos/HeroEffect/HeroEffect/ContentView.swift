//
//  ContentView.swift
//  HeroEffect
//
//  Created by Lurich on 2024/2/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    CardView(item: item)
                }
            }
        }
    }
}
struct CardView: View {
    let item: Item
    @State private var expandSheet: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            SourceView(id: item.id.uuidString) {
                ImageView()
            }
            
            Text(item.title)
            
            Spacer(minLength: 0)
        }
        .contentShape(.rect)
        .onTapGesture {
            expandSheet.toggle()
        }
        .sheet(isPresented: $expandSheet, content: {
            DestinationView(id: item.id.uuidString) {
                ImageView()
                    .onTapGesture {
                        expandSheet.toggle()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .interactiveDismissDisabled()
            .padding()
        })
        .heroLayer(id: item.id.uuidString, animate: $expandSheet) {
            ImageView()
        } completion: { _ in
            
        }

    }
    
    @ViewBuilder
    func ImageView() -> some View {
        Image(systemName: item.symbol)
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(item.color.gradient, in: .circle)
    }
}

/// Demo Item Model
struct Item: Identifiable {
    var id: UUID = .init()
    var title: String
    var color: Color
    var symbol: String
}
var items: [Item] = [
    .init(title: "Book Icon", color: .red, symbol: "book.fill"),
    .init(title: "Stack Icon", color: .blue, symbol: "square.stack.3d.up"),
    .init(title: "Rectangle Icon", color: .orange, symbol: "rectangle.portrait")
]

#Preview {
    ContentView()
}


struct TestViewDemo: View {
    @State private var showView1: Bool = false
    private let viewID1: String = "1"
    @State private var showView2: Bool = false
    private let viewID2: String = "2"
    @State private var showView3: Bool = false
    private let viewID3: String = "3"
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showView1.toggle()
                }, label: {
                    SourceView(id: viewID1) {
                        TestView()
                            .frame(width: 50, height: 50)
                            .overlay {
                                Text(viewID1)
                            }
                    }
                })
                
                Button(action: {
                    showView2.toggle()
                }, label: {
                    SourceView(id: viewID2) {
                        TestView()
                            .frame(width: 50, height: 50)
                            .overlay {
                                Text(viewID2)
                            }
                    }
                })
                
                Button(action: {
                    showView3.toggle()
                }, label: {
                    SourceView(id: viewID3) {
                        TestView()
                            .frame(width: 50, height: 50)
                            .overlay {
                                Text(viewID3)
                            }
                    }
                })
                
            }
            .foregroundStyle(.white)
            .padding()
            .navigationTitle("Hero")
            .navigationDestination(isPresented: $showView1) {
                DestinationView(id: viewID1) {
                    TestView()
                        .frame(width: 100, height: 100)
                        .overlay(content: {
                            Text("Click me to back")
                                .foregroundStyle(.white)
                        })
                        .onTapGesture {
                            showView1.toggle()
                        }
                }
                .padding(15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .navigationBarBackButtonHidden()
                .navigationTitle("Detail View")
            }
        }
        .sheet(isPresented: $showView2, content: {
            DestinationView(id: viewID2) {
                TestView()
                    .frame(width: 150, height: 150)
                    .overlay(content: {
                        Text("Click me to back")
                            .foregroundStyle(.white)
                    })
                    .onTapGesture {
                        showView2.toggle()
                    }
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .interactiveDismissDisabled()
        })
        .fullScreenCover(isPresented: $showView3, content: {
            DestinationView(id: viewID3) {
                TestView()
                    .frame(width: 200, height: 200)
                    .overlay(content: {
                        Text("Click me to back")
                            .foregroundStyle(.white)
                    })
                    .onTapGesture {
                        showView3.toggle()
                    }
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        })
        .heroLayer(id: viewID1, animate: $showView1) {
            TestView()
        } completion: { status in
            print(status ? "open" : "closed")
        }
        .heroLayer(id: viewID2, animate: $showView2) {
            TestView()
        } completion: { status in
            print(status ? "open" : "closed")
        }
        .heroLayer(id: viewID3, animate: $showView3) {
            TestView()
        } completion: { status in
            print(status ? "open" : "closed")
        }

    }
}

struct TestView: View {
    var body: some View {
        Circle()
            .fill(.red)
    }
}
