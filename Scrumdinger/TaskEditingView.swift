import SwiftUI

struct TaskEditingView: View {
    @Binding var isPresented: Bool
    var taskToEdit: Task? // Optional task to edit
    @EnvironmentObject var taskList: TaskList
    @State private var taskName: String = ""
    @State private var taskHours: String = ""
    @State private var taskEmoji: String = "🎯"
    
    init(isPresented: Binding<Bool>, taskToEdit: Task? = nil) {
        self._isPresented = isPresented
        self.taskToEdit = taskToEdit
        // Check if there is a task to edit and initialize the state variables accordingly
        if let task = taskToEdit {
            _taskName = State(initialValue: task.name)
            _taskHours = State(initialValue: String(task.targetTime))
            _taskEmoji = State(initialValue: task.emoji)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $taskName)
                TextField("Target to put in how many hours", text: $taskHours)
                    .keyboardType(.numberPad)
                EmojiPickerView(selectedEmoji: $taskEmoji) // Use the emoji picker
                
                // Delete Task button only appears when editing an existing task
                if taskToEdit != nil {
                    Button(action: deleteTask) {
                        HStack {
                            Spacer()
                            Text("Delete Task")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(taskToEdit != nil ? "Edit Task" : "Add Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                saveTask()
                isPresented = false
            })
        }
    }
    
    private func saveTask() {
        if let task = taskToEdit {
            // Update the existing task
            task.name = taskName
            task.targetTime = Int(taskHours) ?? 0
            task.emoji = taskEmoji
            // Trigger an update in the task list
            taskList.updateTask(task)
        } else {
            // Create a new task
            let newTask = Task(id: UUID(), name: taskName, targetTime: Int(taskHours) ?? 0, emoji: taskEmoji)
            taskList.addTask(newTask)
        }
        isPresented = false
    }
    
    private func deleteTask() {
        guard let task = taskToEdit else { return }
        taskList.deleteTask(task)
        isPresented = false
    }
}

struct EmojiButton: View {
    let emoji: String
    @Binding var selectedEmoji: String
    
    var body: some View {
        Text(emoji)
            .font(.largeTitle)
            .background(self.selectedEmoji == emoji ? Color.gray : Color.clear)
            .cornerRadius(10)
            .onTapGesture {
                self.selectedEmoji = emoji
            }
    }
}

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    let emojis = ["🎯", "🏀", "📚", "🧗‍♀️", "🔥", "🎉", "👩‍💻", "💼", "💐", "🍵", "🍕", "🏃‍♀️"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 10) {
            ForEach(emojis, id: \.self) { emoji in
                EmojiButton(emoji: emoji, selectedEmoji: $selectedEmoji)
            }
        }
        .padding()
    }
}


struct TaskEditingView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock task for editing to the TaskEditingView
        TaskEditingView(isPresented: .constant(true), taskToEdit: Task(name: "Sample Task", targetTime: 60, emoji: "📚"))
            .environmentObject(TaskList())
    }
}
