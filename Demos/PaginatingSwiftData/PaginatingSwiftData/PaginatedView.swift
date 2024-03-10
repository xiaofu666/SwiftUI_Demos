//
//  PaginatedView.swift
//  PaginatingSwiftData
//
//  Created by Lurich on 2024/3/8.
//

import SwiftUI
import SwiftData

@Model
class Country {
    var name: String
    var code: String
    var english: String
    
    init(name: String, code: String, english: String) {
        self.name = name
        self.code = code
        self.english = english
    }
}


struct PaginatedView<Content: View>: View {
    var itemsPerPage: Int = 10
    @Binding var paginationOffset: Int?
    @ViewBuilder var content: ([Country]) -> Content
    @State private var countries: [Country] = []
    @Environment(\.modelContext) private var context
    
    var body: some View {
        content(countries)
            .onChange(of: paginationOffset) { oldValue, newValue in
                do {
                    guard let newValue else { return }
                    var descriptor = FetchDescriptor<Country>()
                    let totalCount = try context.fetchCount(descriptor)
                    descriptor.fetchLimit = itemsPerPage
                    let pageOffset = min(min(totalCount, newValue), countries.count)
                    descriptor.fetchOffset = pageOffset
                    if totalCount == countries.count {
                        paginationOffset = totalCount
                    } else {
                        let newData = try context.fetch(descriptor)
                        countries.append(contentsOf: newData)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

extension View {
    @ViewBuilder
    func customOnAppear(_ callOnce: Bool = true, action: @escaping () -> ()) -> some View {
        self
            .modifier(CustomOnAppearModifier(callOnce: callOnce, action: action))
    }
}

fileprivate struct CustomOnAppearModifier: ViewModifier {
    var callOnce: Bool
    var action: () -> ()
    
    @State private var isTriggered: Bool = false
    func body(content: Content) -> some View {
        content
            .onAppear() {
                if callOnce {
                    if !isTriggered {
                        action()
                        isTriggered = true
                    }
                } else {
                    action()
                }
            }
    }
}
