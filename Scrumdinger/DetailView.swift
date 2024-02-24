/*
 目标详情面板。
 */

import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum
    @State private var data: DailyScrum.Data = DailyScrum.Data()
    @State private var isPresented = false
    @EnvironmentObject var taskList: TaskList // Ensure you have access to your TaskList

    var body: some View {
        List {
            Section(header: Text("My Goal")) {
                NavigationLink(
                    destination: MeetingView(scrum: $scrum)) {
                        Label("Let's Go", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .accessibilityLabel(Text("Start meeting"))
                    }
                HStack {
                    Label("Target Hours", systemImage: "clock")
                        .accessibilityLabel(Text("Meeting length"))
                    Spacer()
                    Text("\(scrum.lengthInHours) hours")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(scrum.color)
                }
                .accessibilityElement(children: .ignore)
            }
            // Add a new section for the associated task
            Section(header: Text("Associated Task")) {
                if let corrTaskId = scrum.corrTaskId, let task = taskList.tasks.first(where: { $0.id == corrTaskId }) {
                    Label(task.name, systemImage: "checkmark.circle")
                    Text("Accumulated Time: \(task.accumTime) minutes")
                } else {
                    Text("No task associated")
                }
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = scrum.data
        })
        .navigationTitle(scrum.title)
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $data, corrTaskId: $scrum.corrTaskId)
                    .navigationTitle(scrum.title)
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done") {
                        isPresented = false
                        scrum.update(from: data)
                    })
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: .constant(DailyScrum.data[0])).environmentObject(TaskList.shared)
        }
    }
}
