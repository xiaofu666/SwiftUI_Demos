//
//  ContentView.swift
//  PayWall-StoreKit
//
//  Created by Xiaofu666 on 2025/5/14.
//

import SwiftUI
import StoreKit

/// IAP View Images
enum IAPImage: String,CaseIterable {
    /// 原始值代表资产图像
    case one = "Profile 0"
    case two = "Profile 1"
    case three = "Profile 2"
    case four = "Profile 3"
    case five = "Profile 4"
    case six = "Profile 5"
    case seven = "Profile 6"
    case eight = "Profile 7"
    case nine = "Profile 8"
    case ten = "Profile 9"
}

struct ContentView: View {
    @State private var isLoadingCompleted: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            SubscriptionStoreView(productIDs: Self.productIDs, marketingContent: {
                CustomMarketingView()
            })
            .subscriptionStoreControlStyle(.pagedProminentPicker, placement: .bottomBar)
            .subscriptionStorePickerItemBackground(.ultraThinMaterial)
            .storeButton(.visible, for: .restorePurchases)
            .storeButton(.hidden, for: .policies)
            .manageSubscriptionsSheet(isPresented: .constant(true))
            .onInAppPurchaseStart { product in
                print("Show Loading Screen")
                print("Purchasing \(product.displayName)")
            }
            .onInAppPurchaseCompletion { product, result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(_): print("Success and verify purchase using verification result")
                    case .pending: print("Pending Action")
                    case .userCancelled: print("User Cancelled")
                    @unknown default:
                        fatalError()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                print("Hide Loading Screen")
            }
            .subscriptionStatusTask(for: "693FD3ED") { status in
                if let result = status.value {
                    let premiumUser = !result.filter({ $0.state == .subscribed }).isEmpty
                    print("User Subscribed = \(premiumUser)")
                }
            }
            
            HStack(spacing: 3) {
                Link("Terms of Service", destination: URL(string:"https://apple.com")!)
                Text("And")
                Link("Privacy Policy", destination: URL(string: "https://apple.com")!)
            }
            .font(.caption)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(isLoadingCompleted ? 1 : 0)
        .background(BackdropView())
        .overlay {
            if !isLoadingCompleted {
                ProgressView()
                    .font(.largeTitle)
                    .ignoresSafeArea()
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isLoadingCompleted)
        .storeProductsTask(for: Self.productIDs) { @MainActor collection in
            if let products = collection.products, products.count == Self.productIDs.count {
                try? await Task.sleep(for: .seconds(0.1))
                isLoadingCompleted = true
            }
        }
//        .preferredColorScheme(.dark)
        .environment(\.colorScheme, .dark)
        .tint(.white)
    }
    
    static var productIDs: [String] {
        return ["pro_weekly", "pro_monthly", "pro_yearly"]
    }
    
    //Backdrop View1
    @ViewBuilder
    func BackdropView() -> some View {
        GeometryReader {
            let size = $0.size
            /// This is a Dark image, but you can use your own image as per your needs!
            Image("Profile 2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .scaleEffect(1.5)
                .blur(radius: 70, opaque: true)
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.2))
                }
        }
        .ignoresSafeArea()
    }

    // Custom Marketing View(Header View)
    @ViewBuilder
    func CustomMarketingView() -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 25) {
                ScreenshotsView([.one, .two, .three], offset: -200)
                ScreenshotsView([.four, .five, .six], offset: -350)
                ScreenshotsView([.seven, .eight, .nine], offset: -250)
                    .overlay(alignment: .trailing) {
                        ScreenshotsView([.seven, .five, .one], offset: -150)
                            .visualEffect { content, proxy in
                                content
                                    .offset(x: proxy.size.width + 25)
                            }
                    }
            }
            .frame(maxHeight: .infinity)
            .offset(x: 20)
            .mask {
                LinearGradient(colors: [
                    .white,
                    .white.opacity(0.9),
                    .white.opacity(0.7),
                    .white.opacity(0.4),
                    .clear
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .padding(.bottom, -40)
            }
            
            /// Replace with your App Information
            VStack(spacing: 6) {
                Text("App Name")
                    .font(.title3)
                
                Text("Membership")
                    .font(.largeTitle.bold())
                
                Text("Lorem Ipsum is simply dummy text\nof the printing and typesetting industry.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(.white)
            .padding(.top, 15)
            .padding(.bottom, 18)
            .padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder
    func ScreenshotsView(_ content: [IAPImage], offset: CGFloat) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                ForEach(content.indices, id: \.self) { index in
                    Image(content[index].rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 220)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                }
            }
            .offset(y: offset)
        }
        .scrollDisabled(true)
        .scrollIndicators(.hidden)
        .rotationEffect(.init(degrees: -30), anchor: .bottom)
        .scrollClipDisabled()
    }
}

#Preview {
    ContentView()
}
