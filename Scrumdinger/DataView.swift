/*
 数据显示面板
 */

import SwiftUI

struct DataView: View {
    @ObservedObject var taskList: TaskList

    var body: some View {
        NavigationView {
            List {
                ForEach(taskList.getTaskList()) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        HStack {
                            Text(task.name)
                            Spacer()
                            Text("\(task.accumTime) mins")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
        }
    }
}


struct TaskDetailView: View {
    var task: Task

    var body: some View {
        List {
            Section(header: Text("Details")) {
                Text("Name: \(task.name)")
                Text("Accumulated Time: \(task.accumTime) mins")
            }
            Section(header: Text("Records")) {
                ForEach(task.records) { record in
                    VStack(alignment: .leading) {
                        Text("Start: \(record.startTime, formatter: itemFormatter)")
                        Text("End: \(record.endTime, formatter: itemFormatter)")
                        Text("Duration: \(record.duration) mins")
                    }
                }
            }
        }
        .navigationTitle(task.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


