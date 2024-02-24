//
//  TaskView.swift
//  Scrumdinger
//
//  Created by Yuanqi Wang on 2/24/24.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var taskList: TaskList
    @State var hasTask = true
    @State private var addTaskPresent = false
    
    func checkEmpty() {
        if taskList.tasks.isEmpty {
            hasTask = false
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if hasTask {
                    ForEach(taskList.getTaskList()) { task in
                        VStack(alignment: .leading) {
                            Text(task.name)
                                .font(.headline)
                            Text("Accumulated time: " + String(task.accumTime))
                                .font(.subheadline)
                        }
                    }
                } else {
                    Text("No Existing Tasks")
                }
            }
            .navigationTitle("Task List")
            .toolbar {
                Button {
                    let newTask = Task(id: UUID(), name: "test", accumTime: 20)
                    taskList.addTask(newTask)
                    checkEmpty()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        
        Text("Hello, World!")
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
            .environmentObject(TaskList())
    }
}
