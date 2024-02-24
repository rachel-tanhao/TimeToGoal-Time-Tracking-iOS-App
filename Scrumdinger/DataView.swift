import SwiftUI

struct DataView: View {
    @EnvironmentObject var taskList: TaskList
    @State private var hasTask = true
    @State private var showingAddTaskView = false
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
                                Text(task.emoji) // Display the emoji next to the task name
                                    .font(.title) // You can adjust the font size as needed
                                Text(task.name)
                                    .font(.headline)
                                Text("Invested: \(task.accumTime) mins") // Display the invested time
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
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
                TaskEditingView(isPresented: $showingAddTaskView)
                    .environmentObject(taskList)
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
