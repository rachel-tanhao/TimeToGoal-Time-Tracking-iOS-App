/*
 数据显示面板
 */

import SwiftUI

struct DataView: View {
    @ObservedObject var taskList: TaskList

    var body: some View {
        
        NavigationView {
            List {
                ForEach(taskList.tasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        HStack {
                            Text(task.name)
                            Spacer()
                            Text("\(task.accumTime) min")
                        }
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for adding a new task
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func deleteTasks(at offsets: IndexSet) {
        // taskList.tasks.remove(atOffsets: offsets)
        // taskList.save()
    }
}

struct TaskDetailView: View {
    var task: Task

    var body: some View {
        List(task.records) { record in
            VStack(alignment: .leading) {
                Text("Start: \(record.startTime)")
                Text("End: \(record.endTime)")
                Text("Duration: \(record.duration) min")
            }
        }
        .navigationTitle(task.name)
    }
}

