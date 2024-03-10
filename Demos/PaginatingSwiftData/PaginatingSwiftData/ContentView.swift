//
//  ContentView.swift
//  PaginatingSwiftData
//
//  Created by Lurich on 2024/3/8.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var paginationOffset: Int?
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                PaginatedView(paginationOffset: $paginationOffset) { countries in
                    ForEach(countries) { country in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(country.name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(country.code)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            Text(country.english)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .customOnAppear(false) {
                            if let paginationOffset, countries.last == country {
                                self.paginationOffset = paginationOffset + 10
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Countries")
                                    .font(.headline)
                                Text("Count = \(countries.count)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        do {
                            guard let path = Bundle.main.path(forResource: "Countries", ofType: "json") else {
                                print("path 获取失败")
                                return
                            }
                            guard let countries_data = try String(contentsOfFile: path).data(using: .utf8) else {
                                print("data 获取失败")
                                return
                            }
                            guard let countries: [[String : String]] = try JSONSerialization.jsonObject(with: countries_data) as? [[String : String]] else {
                                print("转换数组失败")
                                return
                            }
                            print(countries)
                            for country in countries {
                                if let name = country["name"], let code = country["code"], let english = country["english"] {
                                    context.insert(Country(name: name, code: code, english: english))
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear() {
                if paginationOffset == nil {
                    paginationOffset = 0
                }
                do {
                    let descriptor = FetchDescriptor<Country>()
                    let totalCount = try context.fetchCount(descriptor)
                    print("totalCount = \(totalCount)")
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
