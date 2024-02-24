//
//  TaskEditingView.swift
//  Scrumdinger
//
//  Created by Hao Tan on 2/24/24.
//

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
                TextField("Target to invest __ mins", text: $taskHours)
                    .keyboardType(.numberPad)
                EmojiPickerView(selectedEmoji: $taskEmoji) // Use the emoji picker
            }
            .navigationBarTitle("Add New Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                saveTask()
                isPresented = false
            })
        }
    }
    
    private func saveTask() {
        // Update this function to handle both creating a new task and updating an existing task
        if let task = taskToEdit {
            // Update the existing task
            task.name = taskName
            task.targetTime = Int(taskHours) ?? 0
            task.emoji = taskEmoji
        } else {
            // Create a new task
            let newTask = Task(id: UUID(), name: taskName, targetTime: Int(taskHours) ?? 0, emoji: taskEmoji)
            taskList.addTask(newTask)
        }
        isPresented = false
    }
}




struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    let emojis = ["🎯", "🏀", "📚", "🧗‍♀️", "🔥", "🎉", "👩‍💻", "💼", "💐", "🍵", "🍕", "🏃‍♀️"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 10) {
            ForEach(emojis, id: \.self) { emoji in
                Button(action: {
                    self.selectedEmoji = emoji
                }) {
                    Text(emoji)
                        .font(.largeTitle)
                }
            }
        }
        .padding()
    }
}

struct TaskEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditingView(isPresented: .constant(true))
            .environmentObject(TaskList())
    }
}

