import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @EnvironmentObject var taskList: TaskList

    @Environment(\.presentationMode) var presentationMode


    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color(red: 255/255, green: 243/255, blue: 207/255))
            
            GeometryReader { geometry in
                VStack {
                    MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, scrumColor: .orange)
                        .frame(width: geometry.size.width, alignment: .top) // Aligns the header to the top
                        .padding(.top) // Adds padding at the top inside the safe area
                    
                    Spacer() // This will push everything below it towards the bottom
                    
                    MeetingTimerView(scrumColor: .orange.opacity(0.5), scrumTimer: scrumTimer)
                        .frame(width: geometry.size.width, height: geometry.size.height / 2, alignment: .center) // Centers the timer view
                    
                    Spacer() // This will push everything above it towards the top
                    
                    Button(action: {
                        scrumTimer.stopScrum()
                        let elapsedMinutes = scrumTimer.secondsElapsed / 60
                        taskList.accumulateTime(taskId: scrum.corrTaskId, duration: elapsedMinutes)

//                        NavigationLink(destination: ScrumsView(scrums: $scrum))
//                        isClose.wrappedValue.dismiss()
                        // Dismiss the view
                           presentationMode.wrappedValue.dismiss()

                    }) {
                        Text("Stop")
                            .padding()
                            .background(Color(red: 99/255, green: 122/255, blue: 159/255))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 80) // Adds padding at the bottom of the button

                }
            }
            
            

        }
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor)
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes)
            scrumTimer.startScrum()
        }
        .onDisappear {
            scrumTimer.stopScrum()
            let newHistory = History(lengthInMinutes: scrumTimer.secondsElapsed / 60, lengthInHours: scrumTimer.secondsElapsed / 3600)
            scrum.history.insert(newHistory, at: 0)
        }
    }
}


struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.data[0]))
            .environmentObject(TaskList.shared)
    }
}
