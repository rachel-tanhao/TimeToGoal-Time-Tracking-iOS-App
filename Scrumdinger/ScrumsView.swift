/*
 任务面板
 */

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var taskList: TaskList
    @State private var isPresented = false
    @State private var newScrumData = DailyScrum.Data()
    @State private var activeMeetingScrumID: DailyScrum.ID? = nil
    @State private var selectedScrumID: DailyScrum.ID? = nil // For DetailView navigation
    @State private var isDataViewPresented = false // for DataView navigation

    let saveAction: () -> Void
    
    var body: some View {
        List {
            ForEach(scrums) { scrum in
                ZStack {
                    CardView(scrum: scrum, navigateToMeeting: {
                        activeMeetingScrumID = scrum.id
                    }, navigateToDetail: {
                        selectedScrumID = scrum.id
                        isPresented = true
                    })
                }
                .listRowBackground(scrum.color)
                .onTapGesture {
                    selectedScrumID = scrum.id
                    isPresented = true
                }
            }
        }
        // Toolbar Title
        .navigationTitle("Time to Goal")
        .toolbar {
            // Toolbar left item
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isDataViewPresented = true
                }) {Text("🎯 My goals")}
            }
            // Toolbar right item
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPresented = true
                }) {Image(systemName: "plus")}
            }
        }
        
        // For Toolbar left item: show DataView
        .sheet(isPresented: $isDataViewPresented) {
            DataView().environmentObject(TaskList.shared)
        }
        
        // For Toolbar right item: add a new timer
        .sheet(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $newScrumData, corrTaskId: $newScrumData.corrTaskId)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isPresented = false
                    }, trailing: Button("Add") {
                        let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees,
                                                  lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color,
                                                  lengthInHours: Int(newScrumData.lengthInHours),
                                                  progressHours: Int(newScrumData.progressHours),
                                                  category: newScrumData.category,
                                                  corrTaskId: newScrumData.corrTaskId
                        )
                        scrums.append(newScrum)
                        isPresented = false
                    })

            }
        }
        

        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { self.activeMeetingScrumID != nil },
            set: { _ in self.activeMeetingScrumID = nil }
        )) {
            if let activeMeetingScrumID = activeMeetingScrumID, let scrum = scrums.first(where: { $0.id == activeMeetingScrumID }) {
                MeetingView(scrum: binding(for: scrum))
            } else {
                Text("Error: Scrum not found.")
            }
        }
    }

    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $scrums[scrumIndex]
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.data), saveAction: {}).environmentObject(TaskList.shared)
        }
    }
}
