//
//  WidgetView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/12.
//

import SwiftUI
import WidgetKit
import ActivityKit

@available(iOS 16.1, *)
struct WidgetView: View {
    @State var currentID: String = ""
    @State var currentSelection: Status = .received
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $currentSelection) {
                    Text("Received")
                        .tag(Status.received)
                    Text("Progress")
                        .tag(Status.progress)
                    Text("Ready")
                        .tag(Status.ready)
                } label: {
                }
                .labelsHidden()
                .pickerStyle(.segmented)

                
                Button("Start Activity") {
                    addLiveActivity()
                }
                .padding(.top)
                
                
                Button("Remove Activity") {
                    removeActivity()
                }
                .padding(.top)
            }
            .navigationTitle("Live Activities")
            .padding(15)
            .onChange(of: currentSelection) { newValue in
                if let activity = Activity.activities.first(where: { (activity: Activity<OrderAttributes>) in
                    activity.id == currentID
                }) {
                    print("Activity Found")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        var contentState = activity.contentState
                        contentState.status = currentSelection
                        Task {
                            await activity.update(using: contentState)
                        }
                    }
                }
            }
        }
    }
    
    func removeActivity() {
        if let activity = Activity.activities.first(where: { (activity: Activity<OrderAttributes>) in
            activity.id == currentID
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Task {
                    await activity.end(using: activity.contentState, dismissalPolicy: .immediate)
                    if let activity = Activity<OrderAttributes>.activities.last {
                        currentID = activity.id
                    }
                }
            }
        }
    }
    
    func addLiveActivity() {
        let orderAtrributes = OrderAttributes(orderNumber: 26383, orderItems: "Burger & Milk Shake")
        let intialContentState = OrderAttributes.ContentState()
        
        do {
            let activity = try Activity<OrderAttributes>.request(attributes: orderAtrributes, contentState: intialContentState)
            currentID = activity.id
            print("Activity Added Successfully. id: \(activity.id)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

@available(iOS 16.1, *)
struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
