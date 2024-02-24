/*
  计时器面板。
 */

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @State private var transcript = ""
    @State private var isRecording = false
    private let speechRecognizer = SpeechRecognizer()
    var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    
    var body: some View {
        ZStack {
            // background
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color(red: 193/255, green: 242/255, blue: 176/255))
            VStack(spacing: 20){
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, scrumColor: scrum.color)
                
                MeetingTimerView(scrumColor: scrum.color, countTo: scrumTimer.secondsRemaining)
                
                // MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }

        }
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor)
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes)
        }
        .onDisappear {
            scrumTimer.stopScrum()
            let newHistory = History(lengthInMinutes: scrumTimer.secondsElapsed / 60, lengthInHours: scrumTimer.secondsElapsed / 3600)
            scrum.history.insert(newHistory, at: 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.data[0]))
    }
}
