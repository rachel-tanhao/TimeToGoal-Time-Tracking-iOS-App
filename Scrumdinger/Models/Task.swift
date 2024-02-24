//
//  Task.swift
//  Scrumdinger
//
//  Created by Yuanqi Wang on 2/24/24.
//


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
    fileprivate(set) var records: [Record]
    
    init(id: UUID = UUID(), name: String, accumTime: Int = 0, records: [Record]) {
        self.id = id
        self.name = name
        self.accumTime = accumTime
        self.records = records
    }
}

@MainActor class TaskList: ObservableObject {
    @Published private(set) var tasks: [Task]
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
    
    func getTaskList() -> [Task] {
        return tasks
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: TasksSaveKey)
        }
    }
}

