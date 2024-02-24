import SwiftUI

struct MeetingTimerView: View {
    var scrumColor: Color
    @ObservedObject var scrumTimer: ScrumTimer
    let fillColor : Color = Color(
        red: 187/255, green: 226/255, blue: 236/255)
    var body: some View {
        VStack {
            ZStack {
                // Background Circle
                Circle()
                    .stroke(lineWidth: 24)
                    .opacity(0.3)
                    .foregroundColor(fillColor)
                    .frame(width: 250, height: 250)

                // Progress Fill Circle - Adjusted for countdown
                Circle()
                    .trim(from: 0, to: progress())
                    .stroke(scrumColor, lineWidth: 24)
                    .frame(width: 250, height: 250)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress())
                
                // Displaying the remaining time in mm:ss format
                Text(timeRemainingFormatted)
                    .font(.system(size: 60))
                    .fontWeight(.black)
                    .foregroundColor(.orange.opacity(0.9)) // Changes the text color to orange
            }
        }
    }

    // Calculate progress for countdown
    private func progress() -> CGFloat {
        let totalSeconds = CGFloat(scrumTimer.lengthInMinutes * 60)
        let elapsed = CGFloat(scrumTimer.secondsElapsed)
        return (totalSeconds - elapsed) / totalSeconds
    }

    // Format remaining time as mm:ss
    private var timeRemainingFormatted: String {
        let remainingSeconds = scrumTimer.secondsRemaining
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}

// Preview Provider
struct MeetingTimerView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingTimerView(scrumColor: Color.blue, scrumTimer: ScrumTimer(lengthInMinutes: 2))
    }
}
