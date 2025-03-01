//
//  BookCardView.swift
//  AppleBooks
//
//  Created by Xiaofu666 on 2025/3/1.
//

import SwiftUI

struct BookCardView: View {
    var book: Book
    var parentHorizontalPadding: CGFloat = 15
    var size: CGSize
    var isScrolled: (Bool) -> ()
    @State private var scrollProperties: ScrollGeometry = .init(
        contentOffset: .zero,
        contentSize: .zero,
        contentInsets: .init(),
        containerSize: .zero
    )
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var isPageScrolled: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: (1 + scrollProperties.topInsetProgress) * 10) {
                TopCardView()
                
                OtherTextContents()
                    .padding(.horizontal, 15)
                    .frame(maxWidth: size.width - (parentHorizontalPadding * 2))
                    .padding(.bottom, 50)
            }
            /// 要在滚动时实现缩放效果，只需对水平填充应用负比例。在我们的例子中，水平填充设置为15
            .padding(.horizontal, -parentHorizontalPadding * scrollProperties.topInsetProgress)

        }
        .scrollPosition($scrollPosition)
        .scrollClipDisabled()
        .onScrollGeometryChange(for: ScrollGeometry.self) {
            $0
        } action: { oldValue, newValue in
            scrollProperties = newValue
            isPageScrolled = newValue.offsetY > 0
        }
        .onChange(of: isPageScrolled) { oldValue, newValue in
            isScrolled(newValue)
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(BookScrollEnd(topInset: scrollProperties.contentInsets.top))
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15, style: .continuous)
                .fill(.background)
                .ignoresSafeArea(.all, edges: .bottom)
                .offset(y: scrollProperties.offsetY > 0 ? 0 : -scrollProperties.offsetY)
                .padding(.horizontal, -parentHorizontalPadding * scrollProperties.topInsetProgress)
        }
    }
    
    func TopCardView() -> some View {
        VStack(spacing: 15) {
            FixedHeaderView()
            
            Image(book.thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(.top, 10)
                .clipShape(.rect(cornerRadius: 15))
            
            Text(book.title)
                .serifText(.title2, weight: .bold)
            
            Button {
                
            } label: {
                HStack(spacing: 6) {
                    Text(book.author)
                    
                    Image(systemName: "chevron.right")
                        .font(.callout)
                }
            }
            .padding(.top, -5)
            
            Label(book.rating, systemImage: "star.fill")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("Book")
                        .fontWeight(.semibold)
                    
                    Image(systemName: "info.circle")
                        .font(.caption)
                }
                
                Text("45 Pages")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 10) {
                    Button {
                        
                    } label: {
                        Label("Sample", systemImage: "book.pages")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .tint(.white.opacity(0.2))

                    Button {
                        
                    } label: {
                        Text("Get")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .foregroundStyle(.black)
                    .tint(.white)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 5)
            }
            .padding(15)
            .background(.white.opacity(0.2), in: .rect(cornerRadius: 15))
        }
        .foregroundStyle(.white)
        .padding(15)
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(book.color.gradient)
        }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15, style: .continuous))
    }
    
    /// Other Book Text Contents
    func OtherTextContents() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("From the Publisher")
                .serifText(.title3, weight: .semibold)
            
            Text(dummyText)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .lineLimit(5)
            
            Text("Requirements")
                .serifText(.title3,weight: .semibold)
                .padding(.top, 15)
            
            /// Mock Requirements View
            VStack(alignment: .leading, spacing: 4) {
                Text("Apple Books")
                
                Text("Requires i0s 12 or macos 10.14 or later")
                    .foregroundStyle(.secondary)
                
                Text("iBooks")
                    .padding(.top, 5)
                
                Text("Requires iBooks 3 and i0s 4.3 or later")
                    .foregroundStyle(.secondary)
                
                Text("Versions" )
                    .font(.title3)
                    .fontDesign(.serif)
                    .fontWeight(.semibold)
                    .padding(.top, 25)
                
                Text("Updated Mar 16 2022")
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 5)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
    
    func FixedHeaderView() -> some View {
        HStack(spacing: 10) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    scrollPosition.scrollTo(edge: .top)
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            
            Spacer()

            Button {
                
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }
        }
        .buttonStyle(.plain)
        .font(.title)
        .foregroundStyle(.white, .white.tertiary)
        .padding(.bottom, 10 * scrollProperties.topInsetProgress)
        .padding(.horizontal, parentHorizontalPadding * scrollProperties.topInsetProgress)
        .background {
            GeometryReader { proxy in
                TransparentBlurView()
                    .frame(height: scrollProperties.contentInsets.top + 50)
                    .blur(radius: 10, opaque: true)
                    .frame(height: proxy.size.height, alignment: .bottom)
                    .opacity(scrollProperties.topInsetProgress)
            }
        }
        .padding(.horizontal, -parentHorizontalPadding * scrollProperties.topInsetProgress)
        .offset(y: scrollProperties.offsetY < 20 ? 0 : scrollProperties.offsetY - 20)
        .zIndex(1000)
    }
}

#Preview {
    GeometryReader { proxy in
        BookCardView(book: books[0], parentHorizontalPadding: 30, size: proxy.size) { _ in
            
        }
        .padding(.horizontal, 30)
    }
    .background(.gray.opacity(0.15))
}

struct BookScrollEnd: ScrollTargetBehavior {
    var topInset: CGFloat
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < topInset {
            target.rect.origin = .zero
        }
    }
}

extension View {
    func serifText(_ font: Font, weight: Font.Weight) -> some View {
        self
            .font(font)
            .fontDesign(.serif)
            .fontWeight(weight)
    }
}

extension ScrollGeometry {
    var offsetY: CGFloat {
        contentOffset.y + contentInsets.top
    }
    
    var topInsetProgress: CGFloat{
        guard contentInsets.top > 0 else { return 0 }
        /// 当滚动视图的顶部到达屏幕顶部时，这将提供进度值。
        /// 在这种情况下，0表示初始位置，1表示横视图的顶部已经到达屏幕的顶部！
        return max(min(offsetY / contentInsets.top, 1), 0)
    }
}
