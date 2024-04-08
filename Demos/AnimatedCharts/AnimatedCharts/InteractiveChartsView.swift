//
//  InteractiveChatsView.swift
//  iOS17_New_API_Demo
//
//  Created by Lurich on 2023/6/15.
//

import SwiftUI
import Charts

struct InteractiveChartsView: View {
    @State private var graphType: GraphType = .donut
    @State private var barSelection: String?
    @State private var pieSelection: Double?
    
    var body: some View {
        VStack {
            Picker("", selection: $graphType) {
                ForEach(GraphType.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            
            ZStack {
                if let hightDownloads = sampleDownloads.max(by: {
                    $0.value < $1.value
                }) {
                    if graphType == .bar {
                        ChartPopOverView(hightDownloads.value, hightDownloads.month, true)
                            .opacity(barSelection == nil ? 1 : 0)
                    } else {
                        if let barSelection, let selectionDownloads = sampleDownloads.findDownloads(barSelection) {
                            ChartPopOverView(selectionDownloads, barSelection, true, true)
                        } else {
                            ChartPopOverView(hightDownloads.value, hightDownloads.month, true)
                        }
                    }
                }
            }
            .padding(.vertical)
            
            Chart {
                ForEach(sampleDownloads.sorted(by: { graphType == .bar ? false :
                    $0.value > $1.value
                })) { download in
                    if graphType == .bar {
                        BarMark(
                            x: .value("Month", download.month),
                            y: .value("Downloads", download.value)
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Month", download.month))
                    } else {
                        // iOS 17 New API, Pie/Donut Chart
                        SectorMark(
                            angle: .value("Downloads", download.value),
                            innerRadius: .ratio(graphType == .donut ? 0.61 : 0),
                            angularInset: graphType == .donut ? 6 : 1
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Month", download.month))
                        .opacity(barSelection == nil ? 1 : (barSelection == download.month ? 1 : 0.4))
                    }
                }
                
                if let barSelection {
                    RuleMark(x: .value("Month", barSelection))
                        .foregroundStyle(.gray.opacity(0.35))
                        .offset(y: -5)
                        .zIndex(-10)
                        .annotation(position: .top, alignment: .center, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
                            if let downloads = sampleDownloads.findDownloads(barSelection) {
                                ChartPopOverView(downloads, barSelection, false)
                            }
                        }
                }
            }
            .chartXSelection(value: $barSelection)
            .chartAngleSelection(value: $pieSelection)
            .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 20)
            .frame(height: 200)
            .padding(.top, 10)
            .animation(graphType == .bar ? .none : .snappy, value: graphType)
            
            Spacer(minLength: 0)
        }
        .padding()
        .navigationTitle("Interactive Chart's'")
        .onChange(of: pieSelection, initial: false) { oldValue, newValue in
            if let newValue {
                findDownload(newValue)
            } else {
                barSelection = nil
            }
        }
    }
    
    @ViewBuilder
    func ChartPopOverView(_ downloads: Double, _ month: String, _ isTitleView: Bool, _ isSelection: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text("\(isTitleView && !isSelection ? "Highest" : "App") Downloads")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(alignment: .center, spacing: 4, content: {
                Text(String(format: "%.0f", downloads))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(month)
                    .font(.title3)
                    .textScale(.secondary)
            })
        })
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(.gray.opacity(isTitleView ? 0 : 0.15), in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
    }
    
    func findDownload(_ rangeValue: Double) {
        var initialValue: Double = 0.0
        let convertedArray = sampleDownloads.sorted(by: { graphType == .bar ? false :
            $0.value > $1.value
        }).compactMap { download -> (String, Range<Double>) in
            let rangeEnd = initialValue + download.value
            let tuple = (download.month, initialValue ..< rangeEnd)
            initialValue = rangeEnd
            return tuple
        }
        if let download = convertedArray.first(where: { tuple in
            tuple.1.contains(rangeValue)
        }) {
            barSelection = download.0
        }
    }
}

#Preview {
    NavigationStack {
        InteractiveChartsView()
    }
}

enum GraphType: String, CaseIterable {
    case bar = "Bar Chat"
    case pie = "Pie Chat"
    case donut = "Donut Chat"
}
