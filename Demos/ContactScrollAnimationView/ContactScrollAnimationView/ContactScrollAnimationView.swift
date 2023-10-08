//
//  Home.swift
//  ContactScrollAnimation1212
//
//  Created by Lurich on 2022/12/12.
//

import SwiftUI

struct Character: Identifiable {
    var id: String = UUID().uuidString
    var value: String
    var index: Int = 0
    var rect: CGRect = .zero
    var pushOffset: CGFloat = 0
    var isCurrent: Bool = false
    var color: Color = .clear
}

@available(iOS 16.0, *)
struct ContactScrollAnimationView: View {
    @State var characters: [Character] = []
    @GestureState var isDragging: Bool = false
    @State var offsetY: CGFloat = 0
    @State var isDrag: Bool = false
    @State var currentActiveIndex: Int = 0
    @State var startOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ScrollViewReader(content: { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(characters) {character in
                            ContactForCharacter(character: character)
                                .id(character.index)
                        }
                    }
                    .padding(.top, 15)
                    .padding(.trailing, 100)
                }
                .onChange(of: currentActiveIndex) { newValue in
                    if isDrag {
                        withAnimation(.easeInOut(duration: 0.15)){
                            proxy.scrollTo(currentActiveIndex, anchor: .top)
                        }
                    }
                }
                .navigationTitle("联系人")
            })
            .getMinY(coordinateSpace: .named("ContactScrollAnimationView"), completion: { minY in
                if minY != startOffset {
                    startOffset = minY
                }
            })
        }
        .overlay(alignment: .trailing, content: {
            CustomScroller()
                .padding(.top, 35)
        })
        .onAppear {
            characters = fetchCharacters()
            characterElevation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                updateElevation(index: 0)
            }
        }
    }
    
    @ViewBuilder
    func CustomScroller() -> some View {
        GeometryReader{proxy in
            let rect = proxy.frame(in: .named("ContactScrollAnimationView"))
            
            VStack(spacing: 0) {
                ForEach($characters) {$character in
                    HStack(spacing: 15) {
                        GeometryReader{innerProxy in
                            let origin = innerProxy.frame(in: .named("ContactScrollAnimationView"))
                            
                            Text(character.value)
                                .font(.callout)
                                .fontWeight(character.isCurrent ? .bold : .semibold)
                                .foregroundColor(character.isCurrent ? .black : .gray)
                                .scaleEffect(character.isCurrent ? 1.4 : 0.8)
                                .contentTransition(.interpolate)
                                .frame(width: origin.size.width, height: origin.size.height, alignment: .trailing)
                                .overlay {
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(width: 15, height: 0.8)
                                        .offset(x: 35)
                                }
                                .offset(x: character.pushOffset)
                                .animation(.easeInOut(duration: 0.2), value: character.pushOffset)
                                .animation(.easeInOut(duration: 0.2), value: character.isCurrent)

                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        character.rect = origin
                                    }
                                }
                        }
                        .frame(width: 20)
                        
                        ZStack {
                            if characters.first?.id == character.id {
                                ScrollerKnob(character: $character, rect: rect)
                            }
                        }
                        .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .frame(width: 55)
        .padding(.trailing, 10)
        .coordinateSpace(name: "ContactScrollAnimationView")
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func ScrollerKnob(character: Binding<Character>, rect: CGRect) -> some View {
        Circle()
            .fill(.black)
            .overlay(content: {
                Circle()
                    .fill(.white)
                    .scaleEffect(isDragging ? 0.8 : 0.00001)
            })
            .scaleEffect(isDragging ? 1.35 : 1)
            .offset(y: offsetY)
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($isDragging, body: { _, out, _ in
                        out = true
                    })
                    .onChanged({ value in
                        isDrag = true
                        var translation = value.location.y - 20
                        translation = min(translation, rect.maxY - 20)
                        translation = max(translation, rect.minY)
                        offsetY = translation
                        characterElevation()
                    })
                    .onEnded({ value in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            isDrag = false
                        }
                        if characters.indices.contains(currentActiveIndex) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                offsetY = characters[currentActiveIndex].rect.minY
                            }
                        }
                    })
            )
    }
    
    func characterElevation() {
        if let index = characters.firstIndex(where: { character in
            character.rect.contains(CGPoint(x: 0, y: offsetY))
        }) {
            updateElevation(index: index)
           
        }
    }
    
    func updateElevation(index: Int) {
        var modifiedIndicies:[Int] = []
        
        characters[index].pushOffset = -35
        characters[index].isCurrent = true
        modifiedIndicies.append(index)
        currentActiveIndex = index
        let otherOffsets: [CGFloat] = [-25, -15, -5]
        
        for index_ in otherOffsets.indices {
            let newIndex = index + (index_ + 1)
            let newIndex_Negative = index - (index_ + 1)
            if verifyAndUpdate(index: newIndex, offset: otherOffsets[index_]) {
                modifiedIndicies.append(newIndex)
            }
            if verifyAndUpdate(index: newIndex_Negative, offset: otherOffsets[index_]) {
                modifiedIndicies.append(newIndex_Negative)
            }
        }
        
        for index_ in characters.indices {
            if !modifiedIndicies.contains(index_) {
                characters[index_].pushOffset = 0
                characters[index_].isCurrent = false
            }
        }
    }
    
    func verifyAndUpdate(index: Int, offset: CGFloat) -> Bool {
        if characters.indices.contains(index) {
            characters[index].pushOffset = offset
            characters[index].isCurrent = false
            return true
        }
        return false
    }
    
    @ViewBuilder
    func ContactForCharacter(character: Character) -> some View {
        VStack(alignment: .leading, spacing: 15){
            Text(character.value)
                .font(.largeTitle.bold())
            
            ForEach(1...4, id: \.self) {_ in
                HStack(spacing: 10) {
                    Circle()
                        .fill(character.color.gradient)
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(character.color.opacity(0.6).gradient)
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(character.color.opacity(0.4).gradient)
                            .frame(height: 20)
                            .padding(.trailing, 80)
                    }
                }
            }
        }
        .padding(15)
        .getMinY(coordinateSpace: .named("ContactScrollAnimationView"), completion: { minY in
            let index = character.index
            
            if minY > 20 && minY < startOffset && !isDrag {
                updateElevation(index: index)
                withAnimation(.easeInOut(duration: 0.15)) {
                    offsetY = characters[index].rect.minY
                }
            }
        })
    }
    
    func fetchCharacters() ->[Character] {
        let alphabets: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var characters: [Character] = []
        
        characters = alphabets.compactMap({ character -> Character? in
            return Character(value: String(character))
        })
        
        let colors: [Color] = [.red, .yellow, .pink, .orange, .cyan, .indigo, .purple, .blue]
        
        for index in characters.indices {
            characters[index].index = index
            characters[index].color = colors.randomElement()!
        }
        
        return characters
    }
}

@available(iOS 16.0, *)
struct ContactScrollAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ContactScrollAnimationView()
    }
}

