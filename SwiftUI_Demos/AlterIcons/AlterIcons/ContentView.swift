//
//  ContentView.swift
//  AlterIcons
//
//  Created by Xiaofu666 on 2024/10/13.
//

import SwiftUI

enum AppIcon: String, CaseIterable {
    case appIcon = "Default"
    case appIcon2 = "AppIcon2"
    case appIcon3 = "AppIcon3"
    
    var iconValue: String? {
        if self == .appIcon {
            return nil
        } else {
            return rawValue
        }
    }
    
    var previewImage: String {
        switch self {
        case .appIcon:
            "Logo 1"
        case .appIcon2:
            "Logo 2"
        case .appIcon3:
            "Logo 3"
        }
    }
}

struct ContentView: View {
    @State private var currentAppIcon: AppIcon = .appIcon
    
    var body: some View {
        NavigationStack {
            List {
                Section("Choose a App Icon") {
                    ForEach(AppIcon.allCases, id: \.rawValue) { appIcon in
                        HStack(spacing: 15) {
                            Image(appIcon.previewImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(.rect(cornerRadius: 10))
                            
                            Text(appIcon.rawValue)
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: currentAppIcon == appIcon ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(currentAppIcon == appIcon ? Color.green : Color.primary)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            currentAppIcon = appIcon
                            UIApplication.shared.setAlternateIconName(appIcon.iconValue)
                        }
                    }
                }
            }
            .navigationTitle("App Icons")
        }
        .onAppear() {
            if let alterNativeAppIcon = UIApplication.shared.alternateIconName, let appIcon = AppIcon.allCases.first(where: { alterNativeAppIcon == $0.rawValue }) {
                currentAppIcon = appIcon
            } else {
                currentAppIcon = .appIcon
            }
        }
    }
}

#Preview {
    ContentView()
}
