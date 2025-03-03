//
//  ContentView.swift
//  AppShortcuts
//
//  Created by Xiaofu666 on 2025/3/3.
//

import SwiftUI
import SwiftData
import AppIntents

@Model
class Memory {
    var caption: String
    var date: Date
    @Attribute(.externalStorage)
    var imageData: Data
    
    init(caption: String, date: Date = .now, imageData: Data) {
        self.caption = caption
        self.date = date
        self.imageData = imageData
    }
    
    var uiImage: UIImage? {
        .init(data: imageData)
    }
}

struct ContentView: View {
    @Query(sort: [.init(\Memory.date, order: .reverse)], animation: .smooth)
    var memories: [Memory]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(memories) { memory in
                    Section(memory.caption) {
                        if let uiImage = memory.uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Memories")
            .overlay {
                if memories.isEmpty {
                    VStack {
                        Text("No memories yet.")
                            .font(.headline)
                        Text("Tap the plus button to add your first memory.")
                            .foregroundColor(.secondary)
                    }
                    .padding(15)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct AddMemoryIntent: AppIntent {
    static var title: LocalizedStringResource = "Add New Memory"
    /// Getting Image from User
    @Parameter(
        title: .init(stringLiteral: "Choose a Image"),
        description: "Memory to be added",
        /// 任何图像
        supportedContentTypes: [.image],
        /// 我希望参数连接到最后一个（例如，如果我们从照片应用程序中获取一张图像，则可以将该照片传递给此意图，因为该行为被指定为连接行为！）
        inputConnectionBehavior: .connectToPreviousIntentResult
    ) var imageFile: IntentFile
    
    /// 从用户那里获取标题
    @Parameter(title: "Caption") var caption: String
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let container = try ModelContainer(for: Memory.self)
        let context = ModelContext(container)
        let imageData = try await imageFile.data(contentType: .image)
        let memory = Memory(caption: caption, imageData: imageData)
        context.insert(memory)
        try context.save()

        return .result(dialog: "Memory added successfully!")
    }
}

struct AddMemoryShortcut: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoryIntent(),
            phrases:[
                "Create a new \(.applicationName) memory"
            ],
            shortTitle: "Create New Memory",
            systemImageName: "memories"
        )
    }
}
