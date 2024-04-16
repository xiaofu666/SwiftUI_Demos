//
//  ContentView.swift
//  AnimatedMenu
//
//  Created by Lurich on 2024/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu: Bool = false
    
    @State private var isRotatesWhenExpands: Bool = false
    @State private var isDisablesInteraction: Bool = false
    @State private var sideMenuWidth: CGFloat = 200
    @State private var cornerRadius: CGFloat = 0
    @State private var showItem: String = ""
    
    var body: some View {
        AnimatedSideBar(
            rotatesWhenExpands: isRotatesWhenExpands,
            disablesInteraction: isDisablesInteraction,
            sideMenuWidth: sideMenuWidth,
            cornerRadius: cornerRadius,
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack {
                List {
                    Section {
                        Text("\(showItem)")
                    } header: {
                        Text("Selected Item")
                    }
                    
                    Section {
                        Toggle("rotatesWhenExpands", isOn: $isRotatesWhenExpands)
                    } header: {
                        Text("rotatesWhenExpands")
                    }
                    
                    Section {
                        Toggle("disablesInteraction", isOn: $isDisablesInteraction)
                    } header: {
                        Text("disablesInteraction")
                    }
                    
                    Section {
                        Picker("sideMenuWidth", selection: $sideMenuWidth) {
                            Text("200")
                                .tag(CGFloat(200))
                            Text("300")
                                .tag(CGFloat(300))
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("sideMenuWidth")
                    }
                    
                    Section {
                        Picker("sideMenuWidth", selection: $cornerRadius) {
                            Text("0")
                                .tag(CGFloat(0))
                            Text("25")
                                .tag(CGFloat(25))
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("cornerRadius")
                    }
                    
                    NavigationLink("Detail View") {
                        Text("Hello Lurich!")
                            .navigationTitle("Detail")
                    }

                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { showMenu.toggle() }, label: {
                            Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                                .foregroundStyle(Color.primary)
                                .contentTransition(.symbolEffect)
                        })
                    }
                }
            }
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } background: {
            Rectangle()
                .fill(.primary)
        }

    }
    
    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Side Menu")
                .font(.largeTitle.bold())
                .foregroundStyle(.background)
                .padding(.bottom, 10)
            
            let tabs: [Tab] = [.home, .bookmark, .favorites, .profile]
            ForEach(tabs, id: \.title) { tab in
                SideBarButton(tab) {
                    showItem = tab.title
                }
            }
            
            Spacer(minLength: 0)
            
            SideBarButton(.logout) {
                showItem = Tab.logout.title
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func SideBarButton(_ tab: Tab, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: tab.rawValue)
                    .font(.title3)
                
                Text(tab.title)
                    .font(.callout)
                
                Spacer(minLength: 0)
            }
            .padding(.vertical, 10)
            .contentShape(.rect)
            .foregroundStyle(.background)
        }
    }
    
    enum Tab: String,CaseIterable {
        case home = "house.fill"
        case bookmark = "book.fill"
        case favorites = "heart.fill"
        case profile = "person.crop.circle"
        case logout = "rectangle.portrait.and.arrow.forward.fill"
        var title: String {
            switch self {
            case .home: return "Home"
            case .bookmark: return "Bookmark"
            case .favorites: return "Favorites"
            case .profile: return "Profile"
            case .logout: return "Logout"
            }
        }
    }
}

#Preview {
    ContentView()
}
