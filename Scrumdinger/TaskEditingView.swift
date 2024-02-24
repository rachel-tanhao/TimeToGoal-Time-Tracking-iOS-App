//
//  TaskEditingView.swift
//  Scrumdinger
//
//  Created by Hao Tan on 2/24/24.
//

import SwiftUI

struct TaskEditingView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var taskList: TaskList
    @State private var taskName: String = ""
    @State private var taskHours: String = ""
    @State private var taskEmoji: String = "🎯" // Default emoji

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $taskName)
                TextField("Expected Working Hours", text: $taskHours)
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
        guard !taskName.isEmpty, let accumTime = Int(taskHours) else { return }
        let newTask = Task(id: UUID(), name: taskName, accumTime: accumTime, emoji: taskEmoji)
        taskList.addTask(newTask)
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

