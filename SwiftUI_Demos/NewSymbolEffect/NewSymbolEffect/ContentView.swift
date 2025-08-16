//
//  ContentView.swift
//  NewSymbolEffect
//
//  Created by Xiaofu666 on 2025/8/16.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Show Sheet") {
                    isActive = true
                }
            }
            .navigationTitle("Home")
        }
        .sheet(isPresented: $isActive) {
            DrawOnSymbolEffectExample(tint:.blue, data: [
                // YOUR CUSTOM DATA HERE
                .init(
                    name:"chart.bar.xaxis.ascending",
                    title:"Categorized Expenses",
                    subtitle:"Categorize your expenses to see\n where your money is going",
                    preDelay: 0.3
                ),
                .init(
                    name: "magnifyingglass.circle",
                    title: "Search for Expenses",
                    subtitle: "Search for your expenses\nby account or category",
                    preDelay: 1.6
                ),
                .init(
                    name: "square.and.arrow.up",
                    title: "Export Your Data",
                    subtitle: "Now you can export your\nexpense data to PDF or CSV",
                    symbolSize: 65,
                    preDelay: 1.2
                )
            ]) {
                isActive = false
            }
        }
    }
}

struct DrawOnSymbolEffectExample: View {
    var tint: Color = .blue
    var loopDelay: CGFloat = 0.7
    @State var data: [SymbolData]
    var completion: () -> ()
    @State private var currentIndex: Int = 0
    @State private var isDisappeared: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            ZStack {
                ForEach(data) { symbolData in
                    if symbolData.drawOn {
                        Image(systemName: symbolData.name)
                            .font(.system(size: symbolData.symbolSize, weight: .regular))
                            .foregroundStyle(.white)
                            .transition(.symbolEffect(.drawOn.individually))
                    }
                }
            }
            .frame(width:120, height: 120)
            .background {
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .fill(tint.gradient)
            }
            .geometryGroup()
            
            // Title & Subtitle with Numeric Content Transition Effect
            VStack(spacing: 6) {
                Text(data[currentIndex].title)
                    .font(.title2)
                    .lineLimit(1)
                
                Text(data[currentIndex].subtitle)
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .contentTransition(.numericText())
            .animation(.snappy(duration: 1, extraBounce: 0), value: currentIndex)
            .fontDesign(.rounded)
            .frame(maxWidth: 300)
            .frame(height: 80)
            .geometryGroup()
            
            /// Continue Button
            Button {
                completion()
            } label: {
                Text("Start Your Journey")
                    .fontWeight(.semibold)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 2)
            }
            .tint(tint.opacity(0.7))
            .buttonStyle(.borderedProminent)
        }
        .frame(height: 320)
        .presentationDetents([.height(320)])
        .interactiveDismissDisabled()
        .task {
            await loopSymbols()
        }
        .onDisappear() {
            isDisappeared = true
        }
    }
    
    private func loopSymbols() async {
        /// Initial Delay(optional!)
        for index in data.indices {
            await loopSymbol(index)
        }
        
        guard !isDisappeared else { return }
        // Delay to finish the final Draw-off effect
        try? await Task.sleep(for: .seconds(loopDelay))
        await loopSymbols()

    }
    
    private func loopSymbol(_ index: Int) async {
        let symbolData = data[index]
        /// Applying Pre-Delay
        try? await Task.sleep(for:.seconds(symbolData.preDelay))
        /// Drawing Symbol
        data[index].drawOn = true
        ///Updating Current Index
        currentIndex = index
        /// Applying Post-Delay
        try? await Task.sleep(for:.seconds(symbolData.postDelay))
        /// Removing Symbol
        data[index].drawOn = false
    }
    
    struct SymbolData: Identifiable {
        var id: UUID = UUID()
        var name: String
        var title: String
        var subtitle: String
        var symbolSize: CGFloat = 70
        var preDelay: CGFloat = 1
        var postDelay: CGFloat = 2
        fileprivate var drawOn: Bool = false
    }
}

#Preview {
    ContentView()
}
