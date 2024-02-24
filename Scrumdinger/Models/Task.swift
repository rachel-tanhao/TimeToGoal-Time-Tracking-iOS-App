//
//  Task.swift
//  Scrumdinger
//
//  Created by Yuanqi Wang on 2/24/24.
//

import SwiftUI

class Record: Identifiable, Codable {
    var taskID: UUID
    var startTime: Date
    var endTime: Date
    var duration: Int
    
    init(taskID: UUID, startTime: Date, endTime: Date, duration: Int) {
        self.taskID = taskID
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
    }
}

class Task: Identifiable, Codable {
    var id: UUID
    var name: String
    var accumTime: Int
    var emoji: String
    fileprivate(set) var records: [Record]
    
    init(id: UUID = UUID(), name: String, accumTime: Int = 0, emoji: String = "🎯") {
        self.id = id
        self.name = name
        self.accumTime = accumTime
        self.emoji = emoji
        self.records = []
    }
    
    func addRecord(_ rec: Record) {
        records.append(rec)
    }
}

@MainActor class TaskList: ObservableObject {
    // below two lines are for access tasklist in ScrumsView
    static let shared = TaskList()
    @Published var tasks: [Task] = []
    
    let TasksSaveKey = "taskList"
    init() {
        if let data = UserDefaults.standard.data(forKey: TasksSaveKey) {
            if let decoded = try? JSONDecoder().decode([Task].self, from: data) {
                tasks = decoded
                return
            }
        }
        tasks = []
    }
    
    func addTask(_ task: Task){
        tasks.append(task)
        save()
    }
    
    func addRecordToTask(taskId: UUID, record: Record) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].addRecord(record)
            tasks[index].accumTime += record.duration
            save()
        }
    }

    
        
    func getTaskList() -> [Task] {
        return tasks
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: TasksSaveKey)
        }
    }
}


// mock data
extension TaskList {
    static func withMockData() -> TaskList {
        let mockTaskList = TaskList()
        // Add a few mock tasks
        mockTaskList.addTask(Task(name: "Work on SwiftUI", accumTime: 120, emoji: "📚"))
        mockTaskList.addTask(Task(name: "Workout", accumTime: 60, emoji: "🏋️‍♂️"))
        return mockTaskList
    }
}
