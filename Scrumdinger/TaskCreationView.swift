import SwiftUI

struct TaskCreationView: View {
    @Binding var isPresented: Bool
    @Binding var selectedTaskId: UUID? // This will hold the selected or newly created Task ID
    @EnvironmentObject var taskList: TaskList
    @State private var showingTaskEditingView = false
    @State private var newTaskName: String = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select Existing Task")) {
                    ForEach(taskList.tasks) { task in
                        Button(action: {
                            self.selectedTaskId = task.id
                            self.isPresented = false
                        }) {
                            HStack {
                                Text(task.emoji + " " + task.name)
                                Spacer()
                                if selectedTaskId == task.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }

                Section(header: Text("Or Create New Task")) {
                    TextField("New Task Name", text: $newTaskName)
                    Button("Create & Select Task") {
                        createAndSelectNewTask()
                    }
                    .disabled(newTaskName.isEmpty)
                }
            }
            .navigationBarTitle("Select or Create Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }

    private func createAndSelectNewTask() {
        let newTask = Task(name: newTaskName)
        taskList.addTask(newTask)
        self.selectedTaskId = newTask.id
        self.isPresented = false
    }
}

// Assuming EmojiPickerView is defined elsewhere as you provided

