import SwiftUI

struct DataView: View {
    @EnvironmentObject var taskList: TaskList
    @State private var hasTask = true
    @State private var addTaskPresent = false
    @Environment(\.presentationMode) var presentationMode

    // Define columns for your grid
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
                                Text(task.name)
                                    .font(.headline)
                                Text("Invested: \(task.accumTime) mins")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1)) // Adjusted for compatibility
                            .cornerRadius(10)
                        }
                    } else {
                        Text("No Existing Tasks")
                    }
                }
                .padding()
            }
            .navigationTitle("My Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        let newTask = Task(id: UUID(), name: "New Task", accumTime: 20)
                        taskList.addTask(newTask)
                        checkEmpty()
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
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView().environmentObject(TaskList.shared)
    }
}
