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
    var targetTime: Int
    var emoji: String
    fileprivate(set) var records: [Record]
    
    init(id: UUID = UUID(), name: String, accumTime: Int = 0, targetTime: Int = 0, emoji: String = "🎯") {
        self.id = id
        self.name = name
        self.accumTime = accumTime
        self.targetTime = targetTime
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
    
    func accumulateTime(taskId: UUID?, duration: Int) {
        if taskId == nil {
            return
        }
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].accumTime += duration
            save()
        }
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
    
    func accumulateTime(taskId: UUID?, duration: Int) {
        if taskId == nil {
            return
        }
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].accumTime += duration
            save()
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: TasksSaveKey)
        }
    }
    
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            save() // Assuming you have a method to persist changes
        }
    }
    
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            save() // Save changes if necessary
        }
    }

}


// mock data
extension TaskList {
    static func withMockData() -> TaskList {
        let mockTaskList = TaskList()
        // Add a few mock tasks
        mockTaskList.addTask(Task(name: "Work on SwiftUI", accumTime: 60, targetTime: 240, emoji: "📚"))
        mockTaskList.addTask(Task(name: "Workout", accumTime: 20, targetTime: 60,  emoji: "🏋️‍♂️"))
        return mockTaskList
    }
}
