//
//  StackCardView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/19.
//

import SwiftUI

@available(iOS 15.0, *)
struct StackCardView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: User
    
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let index = CGFloat(homeData.getIndex(user: user))
            let topOffset = (index < 2 ? index : 2) * 15
            ZStack {
                Image(user.profilePic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - topOffset, height: size.height)
                    .cornerRadius(10)
                    .offset(y: -topOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation.width
                    offset = isDragging ? translation : .zero
                })
                .onEnded({ value in
                    let width = getScreenRect().width - 50
                    let translation = value.translation.width
                    let checkingState = translation > 0 ? translation : -translation
                    
                    withAnimation {
                        if checkingState > (width / 2) {
                            offset = (translation > 0 ? width : -width) * 2
                            endSwipeActions()
                            // remove card
                            if translation > 0 {
                                rightSwipe()
                            } else {
                                leftSwipe()
                            }
                        } else {
                            offset = .zero
                        }
                    }
                })
        )
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"))) { data in
            guard let info = data.userInfo else {
                return
            }
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let width = getScreenRect().width - 50
            if id == user.id {
                withAnimation {
                    // remove card
                    offset = (rightSwipe ? width : -width) * 2
                    endSwipeActions()
                    // remove card
                    if rightSwipe {
                        self.rightSwipe()
                    } else {
                        self.leftSwipe()
                    }
                }
            }
        }
    }
    
    func getRotation(angle: Double) -> Double {
        return offset / (getScreenRect().width - 50) * angle
    }
    
    func endSwipeActions() {
        withAnimation(.none) {
            endSwipe = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let _ = homeData.displaying_users?.first {
                let _ = withAnimation() {
                    homeData.displaying_users?.removeFirst()
                }
            }
        }
    }
    
    func leftSwipe() {
        // 左滑删除
    }
    func rightSwipe() {
        // 右滑喜欢
    }
}

@available(iOS 15.0, *)
struct StackCardView_Previews: PreviewProvider {
    static var previews: some View {
        TinderCard()
    }
}
