/*
 任务面板
 */

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
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
                .listRowBackground(scrum.color) // should later change based on category
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
        
//        EditView(scrumData: .constant(DailyScrum.data[0].data))

        // For Toolbar right item: add a new timer
        .sheet(isPresented: $isPresented) {
            // Check if we have a selectedScrumID and fetch the corresponding DailyScrum
            if let selectedScrumID = selectedScrumID, let scrumIndex = scrums.firstIndex(where: { $0.id == selectedScrumID }) {
                let selectedScrum = scrums[scrumIndex]

                
                NavigationView {
                    EditView(scrumData: $newScrumData)
                        .navigationBarItems(leading: Button("Dismiss") {
                            isPresented = false

                        }, trailing: Button("Save") {
                            scrums[scrumIndex].update(from: newScrumData) // Update the scrum with new data
                            isPresented = false
                            saveAction() // Call save action
                        })
                }
            } else {
                // Fallback content in case no scrum is selected or found
                Text("Error: Scrum not found or not selected.")
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
            ScrumsView(scrums: .constant(DailyScrum.data), saveAction: {})
        }
    }
}
