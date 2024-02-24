import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data

    @ObservedObject var taskList = TaskList.shared // Use your shared TaskList
    @Binding var corrTaskId: UUID? // Binding to the Scrum's corrTaskId
    @State private var showingTaskCreation = false // To show/hide task creation sheet


    @State private var selectedType: String = "work" // Temporary state
    let types = ["work", "health", "study", "custom"] // should come from backend
    @State private var customType: String = "" // State for custom type input

    

    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $scrumData.title)
                HStack {
                    Slider(value: $scrumData.lengthInHours, in: 1...30, step: 1.0) {
                        Text("Length")
                    }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInHours)) hours"))
                    Spacer()
                    Text("\(Int(scrumData.lengthInHours)) hours")
                        .accessibilityHidden(true)
                }
                Picker("Type", selection: $selectedType) {
                    ForEach(types, id: \.self) { type in
                        Text(type.capitalized)
                            .foregroundColor(colorForType(type: type)) // Set text color based on type
                    }
                }
                // Add TextField for custom type input if "custom" is selected
                if selectedType == "custom" {
                    TextField("Custom Type", text: $customType)
                        .foregroundColor(colorForType(type: "custom"))
                }
            }

            Section(header: Text("Select Task")) {
                ForEach(taskList.tasks) { task in
                    Button(action: {
                        self.corrTaskId = task.id
                    }) {
                        HStack {
                            Text(task.name)
                            Spacer()
                            if corrTaskId == task.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                Button("Create New Task") {
                    self.showingTaskCreation = true
                }
            }
        }
        .sheet(isPresented: $showingTaskCreation) {
            TaskCreationView(isPresented: $showingTaskCreation, selectedTaskId: $corrTaskId)
                .environmentObject(taskList)

        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(scrumData: .constant(DailyScrum.data[0].data), corrTaskId: .constant(nil))
            .environmentObject(TaskList.shared)
    }
}

