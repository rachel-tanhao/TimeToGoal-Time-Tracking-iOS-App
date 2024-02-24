import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color(red: 255/255, green: 243/255, blue: 207/255))
//                .fill(Color(red: 89/255, green: 180/255, blue: 195/255))
            VStack(spacing: 20){
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, scrumColor: scrum.color)
                MeetingTimerView(scrumColor: scrum.color, scrumTimer: scrumTimer)
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
    }
}
