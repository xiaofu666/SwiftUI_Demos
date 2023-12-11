//
//  TaskManager.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI
import CoreData
import QuickLook

@available(iOS 16.0, *)
struct TaskModel: Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskDescription: String
    var taskCategory: Category
}


@available(iOS 16.0, *)
var SampleTasks: [TaskModel] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1677160038), taskName: "学习编程", taskDescription: "完事睡觉", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1677156738), taskName: "Study Video", taskDescription: "测试", taskCategory: .general)
]

@available(iOS 15.0, *)
enum Category: String,CaseIterable {
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return Color("Gray")
        case .bug:
            return Color("Green")
        case .idea:
            return Color("Pink")
        case .modifiers:
            return Color("Blue")
        case .challenge:
            return Color("Purple")
        case .coding:
            return Color.brown
        }
    }
}

@available(iOS 15.0, *)
private extension String {
    var getCategory: Category {
        switch self {
        case "General":
            return Category.general
        case "Bug":
            return Category.bug
        case "Idea":
            return Category.idea
        case "Modifiers":
            return Category.modifiers
        case "Challenge":
            return Category.challenge
        case "coding":
            return Category.coding
        default:
            return Category.bug
        }
    }
}

@available(iOS 16.0, *)
struct TaskManager: View {
    @State var currentDay: Date = .init()
    @State var addNewTask: Bool = false
    // fetching task
//    @State var tasks: [TaskModel] = SampleTasks
    @FetchRequest(entity: TaskManagerData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TaskManagerData.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<TaskManagerData>
    @Environment(\.managedObjectContext) private var context
    @State private var presentShareSheet: Bool = false
    @State private var shareUrl: URL = URL(string: "https://apple.com")!
    @State private var presentFilePicker: Bool = false
    @State private var lookUrl: URL?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TimeLineView()
                .padding(15)
        }
        .navigationTitle("Tasks Manager")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Import") {
                        presentFilePicker.toggle()
                    }
                    Button("Export",action: exportCoreData)
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.init(degrees: -90))
                }
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HeaderView()
        }
        .fullScreenCover(isPresented: $addNewTask) {
//            AddTaskView{ task in
//                tasks.append(task)
//            }
            AddTaskView()
        }
        .sheet(isPresented: $presentShareSheet) {
            deleteTempFile()
        } content: {
            CoreDataShareSheet(url: $shareUrl)
        }
        .fileImporter(isPresented: $presentFilePicker, allowedContentTypes: [.json]) { result in
            switch result {
            case .success(let url):
                print("导入成功 fileUrl = \(url)")
                if tasks.isEmpty {
                    importJSON(url)
                } else {
                    lookUrl = url.absoluteURL
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        //预览文件
        .quickLookPreview($lookUrl)
    }
    func importJSON(_ url: URL) {
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.contextKey] = context
            let items = try decoder.decode([TaskManagerData].self, from: jsonData)
            try context.save()
            print("File Imported Successfully items = \(items)")
        } catch {
            print(error.localizedDescription)
        }
    }
    func deleteTempFile() {
        do {
            try FileManager.default.removeItem(at: shareUrl)
            print("Removed Temp JSON File")
        } catch {
            print(error.localizedDescription)
        }
    }
    func exportCoreData() {
        do {
            if let entityName = TaskManagerData.entity().name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let items = try context.fetch(request).compactMap({ output in
                    output as? TaskManagerData
                })
                let jsonData = try JSONEncoder().encode(items)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    if let tempURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let pathURL = tempURL.appending(component: "Export\(Date().formatted(date: .complete, time: .omitted)).json")
                        try jsonString.write(to: pathURL, atomically: true, encoding: .utf8)
                        shareUrl = pathURL
                        presentShareSheet.toggle()
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @ViewBuilder
    func TimeLineView() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack(alignment: .leading) {
                ForEach(Calendar.current.hours, id: \.self) { hour in
                    TimeLineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
        }
    }
    
    @ViewBuilder
    func TimeLineViewRow(_ date: Date) -> some View {
        HStack {
            Text(date.toString("h a"))
                .ubuntu(14, .regular)
                .frame(width: 45, alignment: .leading)
            
            let calendar = Calendar.current
            let filteredTasks = tasks.filter {
                let taskDate = $0.dateAdded ?? .init()
                if let hour = calendar.dateComponents([.hour], from: date).hour, let taskHour = calendar.dateComponents([.hour], from: taskDate).hour, hour == taskHour && calendar.isDate(taskDate, inSameDayAs: currentDay) {
                    return true
                }
                return false
            }
            
            if filteredTasks.isEmpty {
                Rectangle()
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5],dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y: 10)
            } else {
                /// - Task view
                VStack (spacing: 0) {
                    ForEach(filteredTasks) { task in
                        TaskRow(task)
                    }
                }
            }
            
        }
        .hAligm(.leading)
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func TaskRow(_ task: TaskManagerData) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.taskName ?? "")
                .ubuntu(16, .regular)
                .foregroundColor((task.taskCategory ?? "").getCategory.color)
            if task.taskDescription != "" {
                Text(task.taskDescription ?? "")
                    .ubuntu(14, .light)
                    .foregroundColor((task.taskCategory ?? "").getCategory.color.opacity(0.5))
            }
        }
        .hAligm(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill((task.taskCategory ?? "").getCategory.color)
                    .frame(width: 5)
                
                Rectangle()
                    .fill((task.taskCategory ?? "").getCategory.color.opacity(0.35))
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Today")
                        .ubuntu(30, .light)
                    Text("Welcome to task node")
                        .ubuntu(14, .light)
                }
                .hAligm(.leading)
                
                Button {
                    addNewTask.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Add Task")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background() {
                        Capsule()
                            .fill(Color("Blue").gradient)
                    }
                    .foregroundColor(.white)
                }

            }
            
            Text(Date().toString("MMM YYYY"))
                .ubuntu(16, .medium)
                .hAligm(.leading)
                .padding(.top, 15)
            
            WeekRow()
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                Color("White")
                
                Rectangle()
                    .fill(.linearGradient(colors: [
                        Color("White"),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func WeekRow() -> some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                
                VStack {
                    Text(weekDay.string.prefix(3))
                        .ubuntu(12, .medium)
                    Text(weekDay.date.toString("dd"))
                        .ubuntu(16, status ? .medium : .regular)
                }
                .foregroundColor(status ? Color("Blue") : .gray)
                .hAligm(.center)
                .containerShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.3)) {
                        currentDay = weekDay.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

@available(iOS 16.0, *)
struct TaskManager_Previews: PreviewProvider {
    static var previews: some View {
        TaskManager()
            .preferredColorScheme(.light)
    }
}


struct CoreDataShareSheet: UIViewControllerRepresentable {
    @Binding var url: URL
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
