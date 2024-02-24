/*
 目标追踪主页面板
 */

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    @State private var newScrumData = DailyScrum.Data()
    @State private var activeMeetingScrumID: DailyScrum.ID? = nil
    @State private var selectedScrumID: DailyScrum.ID? = nil // For DetailView navigation

    let saveAction: () -> Void
    
    var body: some View {
        List {
            ForEach(scrums) { scrum in
                ZStack {
                    NavigationLink(destination: DetailView(scrum: binding(for: scrum)), tag: scrum.id, selection: $selectedScrumID) {
                        EmptyView()
                    }
                    .opacity(0)
                    .buttonStyle(PlainButtonStyle())

                    CardView(scrum: scrum, navigateToMeeting: {
                        // Trigger for MeetingView
                        activeMeetingScrumID = scrum.id
                    }, navigateToDetail: {
                        // Trigger navigation to DetailView
                        selectedScrumID = scrum.id
                    })
                }
                .listRowBackground(scrum.color)
                .onTapGesture {
                    // This is to ensure the tap on the CardView (except the button) navigates to DetailView
                    selectedScrumID = scrum.id
                }
            }
        }
        .navigationTitle("Goal Tracking")
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $newScrumData)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isPresented = false
                    }, trailing: Button("Add") {
                        let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees,
                                                  lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
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
            // Assuming MeetingView requires a scrum to initialize
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
