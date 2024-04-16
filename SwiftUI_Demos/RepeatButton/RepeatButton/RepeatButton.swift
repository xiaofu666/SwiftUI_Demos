//
//  RepeatButton.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/17.
//

import SwiftUI

struct RepeatButton: View {
    @State private var count: Int = 0
    @State private var buttonFrames: [ButtonFrame] = []
    
    var body: some View {
        HStack {
            Button(action: {
                if count != 0 {
                    let frame = ButtonFrame(value: count)
                    buttonFrames.append(frame)
                    toggleAnimation(frame.id, false)
                }
            }, label: {
                Image(systemName: "minus")
            })
            
            Text("\(count)")
                .frame(height: 45)
                .padding(.horizontal, 5)
                .frame(minWidth: 45)
                .background(.white.shadow(.drop(color: .black.opacity(0.15), radius: 5)), in: .rect(cornerRadius: 10))
                .overlay {
                    ForEach(buttonFrames) { item in
                        KeyframeAnimator(initialValue: ButtonFrame(value: 0), trigger: item.triggerKeyFrame) { frame in
                            Text("\(item.value)")
                                .background(.black.opacity(0.4-frame.opacity))
                                .offset(frame.offset)
                                .opacity(frame.opacity)
                                .blur(radius: (1-frame.opacity) * 10)
                        } keyframes: { _ in
                            KeyframeTrack(\.offset) {
                                LinearKeyframe(CGSize(width: 0, height: -20), duration: 0.2)
                                LinearKeyframe(CGSize(width: Int.random(in: -2...2), height: -40), duration: 0.2)
                                LinearKeyframe(CGSize(width: Int.random(in: -2...2), height: -70), duration: 0.4)
                            }
                            
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(0.7, duration: 0.2)
                                LinearKeyframe(0 , duration: 0.2)
                            }
                        }

                    }
                }
            
            Button(action: {
                let frame = ButtonFrame(value: count)
                buttonFrames.append(frame)
                toggleAnimation(frame.id)
            }, label: {
                Image(systemName: "plus")
            })
        }
        .buttonRepeatBehavior(.enabled)
        .font(.title).bold()
    }
    
    func toggleAnimation(_ id: UUID, _ increment: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let index = buttonFrames.firstIndex(where: { $0.id == id }) {
                buttonFrames[index].triggerKeyFrame = true
                if increment {
                    count += 1
                } else {
                    count -= 1
                }
            }
        }
    }
    
    func removeFrame(_ id: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            buttonFrames.removeAll(where: { $0.id == id })
        }
    }
}
struct ButtonFrame: Identifiable, Equatable {
    var id: UUID = .init()
    var value: Int
    var offset: CGSize = .zero
    var opacity: CGFloat = 1
    var triggerKeyFrame: Bool = false
}


#Preview {
    RepeatButton()
}
