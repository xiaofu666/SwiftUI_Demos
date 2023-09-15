//
//  PayListView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/11.
//

import SwiftUI

@available(iOS 16.0, *)
struct PayListView: View {
    @State private var expandMenu: Bool = false
    @State private var disContent: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            VStack(spacing: 10) {
                Text("Budgets")
                    .font(.largeTitle)
                    .ubuntu(30, .bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(expandMenu ? Color("Blue") : .white)
                    .contentTransition(.interpolate)
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                
                CardView()
                    .zIndex(1)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(1...20, id:\.self) { index in
                            RowCell(index)
                        }
                    }
                    .padding(.top, 40)
                    .padding([.horizontal, .vertical], 15)
                }
                .padding(.top, -20)
                .zIndex(0)
            }
            .padding(.top, expandMenu ? 30 : -130)
            .overlay {
                Rectangle()
                    .fill(.black)
                    .opacity(disContent ? 0.45 : 0)
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
    }
    
    func animateMenu() {
        if expandMenu {
            withAnimation(.easeInOut(duration: 0.25)) {
                disContent = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expandMenu = false
                }
            }
        } else {
            withAnimation(.easeInOut(duration: 0.35)) {
                expandMenu = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    disContent = true
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader {
            let size = $0.size
            let offset = (size.height + 200.0) * 0.2
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .frame(width: 15, height: 2)
                        .menuTitleView("Back", offset, expandMenu) {
                            dismiss()
                        }
                    
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .frame(width: 25, height: 2)
                        .menuTitleView("Money", (offset * 2), expandMenu) {
                            print("Tapped Money")
                        }
                    
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .frame(width: 20, height: 2)
                        .menuTitleView("Wallets", (offset * 3), expandMenu) {
                            print("Tapped Wallets")
                        }
                }
                .overlay(content: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.white)
                        .scaleEffect(expandMenu ? 1 : 0.001)
                        .rotationEffect(.degrees(expandMenu ? 0 : -180))
                })
                .overlay(content: {
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: animateMenu)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    //
                } label: {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                }

            }
            .padding(15)
        }
        .frame(height: 60)
        .padding(.bottom, expandMenu ? 200 : 130)
        .background {
            Color("Blue")
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CardView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Total")
                    .font(.body)
                    .ubuntu(16, .regular)
                
                Text("$520,1314.00")
                    .font(.largeTitle)
                    .ubuntu(40, .bold)
                    .foregroundColor(Color("Blue"))
                
                Text("-250 today")
                    .ubuntu(12, .light)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                //
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .scaleEffect(0.9)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color("Blue"))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: 10)
            }

        }
        .padding(15)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 10, x: 5, y: 5)
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func RowCell(_ index: Int) -> some View {
        HStack(spacing: 10) {
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                 Text("测试标题\(index)")
                    .font(.title)
                    .ubuntu(16, .medium)
                
                 Text("测试正文\(index)")
                    .font(.body)
                    .ubuntu(12, .regular)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("$5.20")
                .font(.title3)
                .ubuntu(18, .medium)
                .foregroundColor(Color("Blue"))
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
    }
}

@available(iOS 16.0, *)
struct PayListView_Previews: PreviewProvider {
    static var previews: some View {
        PayListView()
    }
}

@available(iOS 16.0, *)
extension View {
    @ViewBuilder
    fileprivate func menuTitleView(_ title: String, _ offset: CGFloat, _ conition: Bool, onTap: @escaping () -> ()) -> some View {
        self
            .foregroundColor(conition ? .clear : .white)
            .contentTransition(.interpolate)
            .background(alignment: .topLeading) {
            Text(title)
                .font(.title)
                .ubuntu(25, .medium)
                .foregroundColor(.white)
                .frame(width: 150, alignment: .leading)
                .scaleEffect(conition ? 1 : 0.01, anchor: .topLeading)
                .offset(y: conition ? -6 : 0)
                .onTapGesture(perform: onTap)
        }
        .offset(x: conition ? 40 : 0, y: conition ? offset : 0)
    }
}
