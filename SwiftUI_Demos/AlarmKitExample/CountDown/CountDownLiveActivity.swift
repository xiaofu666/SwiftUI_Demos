//
//  CountDownLiveActivity.swift
//  CountDown
//
//  Created by Xiaofu666 on 2025/6/28.
//

import WidgetKit
import SwiftUI
import AlarmKit
import AppIntents

struct CountDownLiveActivity: Widget {
    // Number Formatter
    @State private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<CountDownAttribute>.self) { context in
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    /// Title
                    switch context.state.mode {
                    case .countdown(let coundown):
                        Group {
                            Text(context.attributes.presentation.countdown?.title ?? "")
                                .font(.title3)
                            
                            Text(coundown.fireDate, style: .timer)
                                .font(.title2)
                        }
                    case .paused(let paused):
                        Group {
                            Text(context.attributes.presentation.paused?.title ?? "")
                                .font(.title3)
                            
                            Text(formatter.string(from: paused.totalCountdownDuration - paused.previouslyElapsedDuration) ?? "0:00")
                                .font(.title2)
                        }
                    case .alert(_):
                        Group {
                            Text(context.attributes.presentation.alert.title)
                                .font(.title3)
                            
                            Text("0:00")
                                .font(.title2)
                        }
                    @unknown default:
                        fatalError()
                    }
                }
                .lineLimit(1)
                
                Spacer(minLength: 0)
                
                let alarmID = context.state.alarmID
                // Pause and Cancel Buttons!
                Group {
                    if case .paused = context.state.mode {
                        // Resume Button
                        Button(intent: AlarmActionIntent(id: alarmID, isResume: true)) {
                            Image(systemName: "play.fill")
                                .tint(.orange)
                        }
                        .tint(.orange)
                    } else {
                        Button(intent: AlarmActionIntent(id: alarmID)) {
                            Image(systemName: "pause.fill")
                        }
                        .tint(.orange)
                    }
                    
                    Button(intent:AlarmActionIntent(id: alarmID,isCancel: true)) {
                        Image(systemName: "xmark")
                    }
                    .tint(.red)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .font(.title)
                
            }
            .padding(15)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Minimal Content")
            }
            .keylineTint(Color.red)
        }
    }
}
