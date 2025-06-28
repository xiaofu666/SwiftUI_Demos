//
//  ContentView.swift
//  AlarmKitExample
//
//  Created by Xiaofu666 on 2025/6/28.
//

import SwiftUI
import AlarmKit
import AppIntents

struct ContentView: View {
    @State private var isAuthorized: Bool = false
    @State private var scheduleDate: Date = .now
    
    @State private var pre: CGFloat = 20
    @State private var post: CGFloat = 20
    
    var body: some View {
        NavigationStack {
            Group {
                if isAuthorized {
                    AlarmView()
                } else {
                    Text("You need to allow alaims in settings to use this app")
                        .multilineTextAlignment(.center)
                        .padding(10)
                        .glassEffect()
                }
            }
            .navigationTitle("AlarmKit")
        }
        .task {
            do {
                try await checkAndAuthorize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    private func AlarmView() -> some View {
        List {
            Section("Alarm Only") {
                DatePicker("", selection: $scheduleDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                
                Button("Set Alarm") {
                    Task {
                        do {
                            try await setAlarm()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
            Section("Alarm With Countdown") {
                Text("Pre countdown: \(Int(pre))s")
                Slider(value: $pre, in: 20...60, step: 1)
                Text("Post countdown: \(Int(post))s")
                Slider(value: $post, in: 20...60, step: 1)
                
                Button("Set Countdown Alarm") {
                    Task {
                        do {
                            try await setAlarmWithCountdown()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func setAlarm() async throws {
        // Alarm ID
        let id = UUID()
        
        // Secondary Alert Button
        let secondaryButton = AlarmButton(text:
        "Go to App", textColor: .white, systemImageName:
        "app.fill")

        // Alert
        let alert = AlarmPresentation.Alert(
            title: "Time's Up!!!",
            stopButton: .init(text: "stop", textColor: .red, systemImageName: "stop.fill"),
            secondaryButton: secondaryButton,
            secondaryButtonBehavior: .custom
        )
        // Presentation1
        let presentation = AlarmPresentation(alert: alert)
        /// Attributes
        let attributes = AlarmAttributes<CountDownAttribute>(presentation: presentation, metadata: .init(), tintColor: .orange)
        /// Schedule
        let schedule = Alarm.Schedule.fixed(scheduleDate)
        
        /// Configuration
        let config = AlarmManager.AlarmConfiguration(schedule: schedule, attributes: attributes, secondaryIntent: OpenAppIntent(id: id))
        
        /// Adding alarm to the System
        let _ = try await AlarmManager.shared.schedule(id: id, configuration: config)
        print("Alarm Set Successfully")
    }
    
    private func setAlarmWithCountdown() async throws {
        /// Alarm ID
        let id = UUID()
        /// Countdown
        let alarmCountdown = Alarm.CountdownDuration(preAlert: pre, postAlert: post)

        // Secondary Alert Button
        let secondaryButton = AlarmButton(text:
        "Repeat", textColor: .white, systemImageName:
        "arrow.clockwise")

        // Alert
        let alert = AlarmPresentation.Alert(
            title: "Time's Up!!!",
            stopButton: .init(text: "stop", textColor: .red, systemImageName: "stop.fill"),
            secondaryButton: secondaryButton,
            secondaryButtonBehavior: .countdown
        )
        let countdownPresentation = AlarmPresentation.Countdown(
            // Your title to be displayed on Liveactivity, Dynamic Island etc.
            title: "Coding",
            pauseButton: .init(
                text: "Pause",
                textColor: .white,
                systemImageName: "pause.fill"
            )
        )
        let pausedPresentation = AlarmPresentation.Paused(
            // Paused title to be displayed on Liveactivity, Dynamic Island etc.
            title: "Paused!",
            resumeButton: .init(
                text: "Resume",
                textColor: .white,
                systemImageName:"play.fill"
            )
        )

        // Presentation1
        let presentation = AlarmPresentation(alert: alert, countdown: countdownPresentation, paused: pausedPresentation)
        /// Attributes
        let attributes = AlarmAttributes<CountDownAttribute>(presentation: presentation, metadata: .init(), tintColor: .orange)
        /// Configuration
        let config = AlarmManager.AlarmConfiguration(countdownDuration: alarmCountdown, attributes: attributes)
        /// Adding alarm to the System
        let _ = try await AlarmManager.shared.schedule(id: id, configuration: config)
        print("Alarm Set Successfully")
    }
    
    private func checkAndAuthorize() async throws {
        switch AlarmManager.shared.authorizationState {
        case .notDetermined:
            let status = try await AlarmManager.shared.requestAuthorization()
            isAuthorized = status == .authorized
        case .denied:
            isAuthorized = false
        case .authorized:
            isAuthorized = true
        @unknown default:
            fatalError()
        }
    }
}

#Preview {
    ContentView()
}

struct OpenAppIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Opens App"
    static var openAppWhenRun: Bool = true
    static var isDiscoverable: Bool = false
    
    @Parameter
    var id: String
    
    init(id: UUID) {
        self.id = id.uuidString
    }
    
    init() {
    }
    
    func perform()async throws -> some IntentResult {
        if let alarmID = UUID(uuidString: id) {
            print(alarmID)
            // Do your custom code here...
        }
        return .result()
    }
}
