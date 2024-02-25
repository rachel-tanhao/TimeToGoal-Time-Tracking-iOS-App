import SwiftUI

struct DataView: View {
    @EnvironmentObject var taskList: TaskList
    @State private var hasTask = true
    @State private var showingAddTaskView = false
    @State private var selectedTaskForEditing: Task? = nil
    @Environment(\.presentationMode) var presentationMode

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    func checkEmpty() {
        hasTask = !taskList.tasks.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    if hasTask {
                        ForEach(taskList.getTaskList()) { task in
                            VStack(alignment: .leading) {
                                Text(task.emoji)
                                    .font(.title)
                                
                                Text(task.name)
                                    .font(.headline)
                                
                                Text("Expected: \(task.targetTime) hrs")
                                    .font(.subheadline)
                                
                                Text("Invested: \(Double(task.accumTime) / 60, specifier: "%.2f") hrs")
                                    .font(.subheadline)
                                
                                // Calculate progress and ensure it does not exceed 100%
                                let progressPercentage = task.accumTime == 0 ? 0 : min(Double(task.accumTime) / Double(task.targetTime * 60) * 100, 100)
                                Text("Progress: \(progressPercentage, specifier: "%.0f")%")
                                        .font(.subheadline)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(10)
                            .onTapGesture {
                                self.selectedTaskForEditing = task // Set the task to be edited
                                self.showingAddTaskView = true // Trigger the sheet to show TaskEditingView
                            }
                        }
                    } else {
                        Text("No Existing Tasks")
                    }
                }
                .padding()
            
            }
            .navigationTitle("🎯 My Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingAddTaskView = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back")
                    }
                }
            }
            .sheet(isPresented: $showingAddTaskView) {
                if let taskToEdit = selectedTaskForEditing {
                    TaskEditingView(isPresented: $showingAddTaskView, taskToEdit: taskToEdit)
                        // No need to pass taskList here; it's inherited from the environment
                } else {
                    TaskEditingView(isPresented: $showingAddTaskView)
                        // No need to pass taskList here; it's inherited from the environment
                }
            }

        }
        
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
            .environmentObject(TaskList.withMockData()) // Assuming you have implemented the withMockData() method
    }
}
