//
//  ContentView.swift
//  SlideControl
//
//  Created by Xiaofu666 on 2025/4/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                SlideToConfirm(
                    config: SlideToConfirm.Config.init(
                        idleText: "Swipe To Play",
                        onSwipeText: "Confirms Payment",
                        confirmationText: "Success",
                        tint: .green,
                        foregroundColor: .white
                    )) {
                        print("Swiped")
                    }
            }
            .navigationTitle("Slide To Confirm")
        }
    }
}

#Preview {
    ContentView()
}
