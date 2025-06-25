//
//  LatteOrderView.swift
//  OrderLatte
//
//  Created by Xiaofu666 on 2025/6/25.
//

import SwiftUI
import AppIntents

enum LatteOrderPage: String {
    case page1 = "Updating Milk Percentage"
    case page2 = "Updating Latte Count"
    case page3 = "Order Finished"
}

struct LatteOrderView: View {
    var choices: LocalizedStringResource
    var count: Int
    var milkPercentage: Int
    var page: LatteOrderPage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 15) {
                Image(.pic)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(.rect(cornerRadius: 15, style: .continuous))
                
                VStack(alignment: .leading, spacing:4) {
                    Text("Caffe Latte")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Group {
                        Text(choices)
                        
                        if page == .page2 {
                            Text("\(milkPercentage)% Milk")
                        }
                        
                        if page == .page3 {
                            HStack(spacing: 0) {
                                Text("\(milkPercentage)% Milk")
                                
                                Text(" | \(count) Shots")
                            }
                        }
                    }
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
                .foregroundStyle(Color.white)
            }
            
            if page == .page3 {
                Label("Order Placed", systemImage:"checkmark")
                    .frame(height: 40)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial, in: .capsule)
            } else {
                HStack(spacing: 5) {
                    Group {
                        if page == .page1 {
                            Text("\(milkPercentage)% Milk")
                        }
                        
                        if page == .page2 {
                            Text("\(count) Shots")
                        }
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    
                    Spacer(minLength: 0)
                    
                    ActionButton(false)
                    
                    ActionButton(true)
                }
                .foregroundStyle(.white)
            }
        }
        .padding(15)
        .background {
            LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                .clipShape(.containerRelative)
        }
    }
    
    @ViewBuilder
    func ActionButton(_ isIncremeant: Bool) -> some View {
        Button(intent: LatteActionIntent(isUpdatingPercentage: page == .page1, isIncremental: isIncremeant)) {
            Image(systemName: isIncremeant ? "plus":"minus")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(maxWidth: 100)
                .frame(height:40)
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: isIncremeant ? 10 : 30,
                        bottomLeadingRadius: isIncremeant ? 10 : 30,
                        bottomTrailingRadius: isIncremeant ? 30 : 10,
                        topTrailingRadius: isIncremeant ? 30 : 10,
                        style: .continuous
                    )
                        .fill(.ultraThinMaterial)
                }
        }
        .buttonStyle(.plain)
    }
}
