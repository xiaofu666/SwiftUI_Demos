//
//  GradientGenerator.swift
//  GradientGenFM
//
//  Created by Xiaofu666 on 2025/6/21.
//

import SwiftUI
import FoundationModels

struct GradientGenerator: View {
    var onTap: (Palette) -> ()
    // Generator Properties
    @State private var isGenerating: Bool = false
    @State private var generationLimit: Int = 3
    @State private var userPrompt: String = ""
    // View Properties
    @State private var isStopped: Bool = false
    @State private var palettes: [Palette] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Gradient Generator")
                .font(.largeTitle.bold())
            
            ScrollView(palettes.isEmpty ? .vertical : .horizontal) {
                HStack(spacing: 12) {
                    ForEach(palettes) { palette in
                        VStack(spacing: 6) {
                            LinearGradient(colors: palette.swiftUIColors, startPoint: .top, endPoint: .bottom)
                                .clipShape(.circle)
                            
                            Text(palette.name)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxHeight: .infinity)
                        .contentShape(.rect)
                        .onTapGesture {
                            onTap(palette)
                        }
                    }
                    if isGenerating || palettes.isEmpty {
                        VStack(spacing: 6) {
                            KeyframeAnimator(initialValue: 0.0, repeating: true) { rotation in
                                Image(systemName: "apple.intelligence")
                                    .font(.largeTitle)
                                    .rotationEffect(.init(degrees: rotation))
                            } keyframes: { _ in
                                LinearKeyframe(0, duration: 0)
                                LinearKeyframe(360, duration: 5)
                            }

                            if palettes.isEmpty {
                                Text("Start crafting your gradient...")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(15)
            }
            .frame(height: 100)
            .defaultScrollAnchor(.trailing, for: .sizeChanges)
            .disabled(isGenerating)
            
            TextField("Gradient Prompt", text: $userPrompt)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .glassEffect()
                .disableWithOpacity(isGenerating)
            
            // stepper
            Stepper("Generation Limit: **\(generationLimit)**", value: $generationLimit, in: 1...10)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .glassEffect()
                .disableWithOpacity(isGenerating)
            
            Button {
                if isGenerating {
                    isStopped = true
                } else {
                    isStopped = false
                    generatePalettes()
                }
            } label: {
                Text(isGenerating ? "Stop Crafting" : "Craft Gradients")
                    .contentTransition(.numericText())
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.blue.gradient, in: .capsule)
            }
            .disableWithOpacity(userPrompt.isEmpty)
        }
        .safeAreaPadding(15)
        .glassEffect(.regular, in: .rect(cornerRadius: 20, style: .continuous))
    }
    
    private func generatePalettes() {
        Task {
            do {
                isGenerating = true
                let instructions: String = """
                    Generate a smooth gradient color palette based on the user's prompt. The
                    gradient should transition between two or more colors relevant to
                    the theme, mood, or elements described in the prompt. Limit the
                    result to only \(generationLimit) palettes.
                    """
                let session = LanguageModelSession {
                    instructions
                }
                let response = session.streamResponse(to: userPrompt, generating: [Palette].self)
                
                for try await partialResult in response {
                    let palettes = partialResult.compactMap {
                        if let id = $0.id, let name = $0.name, let colors = $0.colors?.compactMap({ $0 }), colors.count > 2 {
                            return Palette(id: id, name: name, colors: colors)
                        }
                        return nil
                    }
                    
                    withAnimation(.smooth(duration: 0.35)) {
                        self.palettes = palettes
                    }
                    
                    if isStopped {
                        print("User -Stopped")
                        isGenerating = false
                        return
                    }
                }
            } catch {
                print(error.localizedDescription)
                isGenerating = false
            }
        }
    }
}

#Preview {
    GradientGenerator() { _ in
        
    }
}

@Generable
struct Palette: Identifiable {
    var id: Int
    @Guide(description:"Gradient Name")
    var name: String
    @Guide(description:"Hex Color Codes")
    var colors: [String]
    
    var swiftUIColors: [Color] {
        colors.compactMap({ .init(hex: $0) })
    }
}

extension View {
    func disableWithOpacity(_ status: Bool) -> some View {
        self
            .disabled(status)
            .opacity(status ? 0.5 : 1)
    }
}

/// Hex to SwiftUI Color Extension
extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#",with: "")
        
        var rgb: UInt64 = 0
        Scanner(string:hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
