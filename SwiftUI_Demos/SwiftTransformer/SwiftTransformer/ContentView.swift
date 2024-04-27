//
//  ContentView.swift
//  SwiftTransformer
//
//  Created by Lurich on 2024/4/22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showView: Bool = false
    @State private var selectedColor: DummyColors = .none
    @Environment(\.modelContext) private var context
    @Query private var storedColors: [ColorModel]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(storedColors) { color in
                    HStack {
                        Circle()
                            .fill(Color(color.color).gradient)
                            .frame(width: 35, height: 35)
                        
                        Text(color.name)
                    }
                    .padding(5)
                }
            }
            .navigationTitle("My Colors")
            .toolbar {
                Button("Add") {
                    showView.toggle()
                }
            }
        }
        .sheet(isPresented: $showView) {
            NavigationStack {
                List {
                    Picker("Select", selection: $selectedColor) {
                        ForEach(DummyColors.allCases, id: \.self) { color in
                            Text(color.rawValue)
                                .tag(color)
                        }
                    }
                }
                .navigationTitle("Choose a color")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", role: .destructive) {
                            showView = false
                            selectedColor = .none
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            let colorModel = ColorModel(name: selectedColor.rawValue, color: selectedColor.color)
                            context.insert(colorModel)
                            selectedColor = .none
                            showView = false
                        }
                        .disabled(selectedColor == .none)
                    }
                }
            }
            .interactiveDismissDisabled()
            .presentationDetents([.height(150)])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ColorModel.self)
}
