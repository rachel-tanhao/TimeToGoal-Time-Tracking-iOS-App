/*
 数据显示面板
 */

import SwiftUI

struct DataView: View {
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
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView().environmentObject(TaskList.shared)
    }
}
