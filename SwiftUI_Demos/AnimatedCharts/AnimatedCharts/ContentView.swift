//
//  ContentView.swift
//  AnimatedCharts
//
//  Created by Lurich on 2024/4/7.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var appDownloads: [Download] = sampleDownloads
    @State private var isAnimated: Bool = false
    @State private var trigger: Bool = false
    @State private var chartType: String = "Bar"
    @State private var animatedItems: Int = 9
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Chart Type", selection: $chartType) {
                        Text("Bar")
                            .tag("Bar")
                        Text("Line")
                            .tag("Line")
                        Text("Pie")
                            .tag("Pie")
                    }
                    .pickerStyle(.segmented)

                } header: {
                    Text("Chart Type")
                }
                
                Section {
                    Picker("Animated Items", selection: $animatedItems) {
                        Text("5")
                            .tag(5)
                        Text("9")
                            .tag(9)
                    }
                    .pickerStyle(.segmented)

                } header: {
                    Text("Animated Items")
                }

                Section {
                    Chart {
                        ForEach(appDownloads) { download in
                            switch chartType {
                            case "Bar":
                                BarMark(
                                    x: .value("Month", download.month),
                                    y: .value("Downloads", download.isAnimated ? download.value : 0)
                                )
                                .foregroundStyle(by: .value("Month", download.month))
                                .opacity(download.isAnimated ? 1 : 0)
                                
                            case "Line":
                                AreaMark(
                                    x: .value("Month", download.month),
                                    y: .value("Downloads", download.isAnimated ? download.value : 0)
                                )
                                .interpolationMethod(.catmullRom) //平滑曲线，还有其他样式
//                                .shadow(color: .black.opacity(0.8), radius: 3) // iOS 16.4新增
                                .foregroundStyle(.linearGradient(colors:[
                                    Color.red.opacity(0.6),
                                    Color.red.opacity(0.3),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                                .opacity(download.isAnimated ? 1 : 0)
                                
                            case "Pie":
                                SectorMark (
                                    angle: .value("Downloads", download.isAnimated ? download.value : 0)
                                )
                                .foregroundStyle(by: .value("Month", download.month))
                                .opacity(download.isAnimated ? 1 : 0)

                            default:
                                BarMark(
                                    x: .value("Month", download.month),
                                    y: .value("Downloads", download.isAnimated ? download.value : 0)
                                )
                                .foregroundStyle(.red.gradient)
                                .opacity(download.isAnimated ? 1 : 0)
                            }
                        }
                    }
                    //必须提供一个动画范围，一般是获取数组最大值
                    .chartYScale(domain: 0...12000)
                    .frame(height: 220)
                    .padding()
                    .background(.background, in: .rect(cornerRadius: 10))
                } header: {
                    Text("Demo")
                }
                
                NavigationLink {
                    InteractiveChartsView()
                } label: {
                    Text("互动性图表")
                }

            }
            .padding()
            .background(.gray.opacity(0.12))
            .navigationTitle("Animated Chart's")
            .onAppear(perform: animateChart)
            .onChange(of: trigger, initial: false) { oldValue, newValue in
                resetChartAnimation()
                animateChart()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "arrow.clockwise") {
                        appDownloads = sampleDownloads
                        appDownloads.append(contentsOf: [
                            .init(date: .createDate(1, 7, 23), value: 4700),
                            .init(date: .createDate(1, 8, 23), value: 7700),
                            .init(date: .createDate(1, 9, 23), value: 1700)
                        ])
                        trigger.toggle()
                    }
                }
            }
        }
    }
    
    private func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        $appDownloads.enumerated().forEach { index, element in
            if index >= animatedItems {
                element.wrappedValue.isAnimated = true
            } else {
                let delay = Double(index) * 0.05
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay) {
                    withAnimation(.smooth) {
                        element.wrappedValue.isAnimated = true
                    }
                }
            }
        }
    }
    
    private func resetChartAnimation() {
        $appDownloads.forEach { download in
            download.wrappedValue.isAnimated = false
        }
        isAnimated = false
    }
}

#Preview {
    ContentView()
}
