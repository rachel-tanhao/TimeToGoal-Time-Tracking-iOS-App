import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data
    @ObservedObject var taskList = TaskList.shared // Use your shared TaskList
    @Binding var corrTaskId: UUID? // Binding to the Scrum's corrTaskId
    @State private var showingTaskCreation = false // To show/hide task creation sheet

    var body: some View {
        List {
            Section(header: Text("Time To Goal")) {
                TextField("Title", text: $scrumData.title)
                HStack {
                    Slider(value: Binding(
                        get: { Double (scrumData.lengthInHours) },
                        set: { newValue in
                            scrumData.lengthInHours = Int (newValue)
                            scrumData.lengthInMinutes = scrumData.lengthInHours * 60
                        }),
                        in: 1...8, step: 1.0) {
                            Text("Length")
                        }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInHours)) hours"))
                    Spacer()
                    Text("\(Int(scrumData.lengthInHours)) hours")
                        .accessibilityHidden(true)
                }
                ColorPicker("Color", selection: $scrumData.color)
                    .accessibilityLabel(Text("Color picker"))

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

