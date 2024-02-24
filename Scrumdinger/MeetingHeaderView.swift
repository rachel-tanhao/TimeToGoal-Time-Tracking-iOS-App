/*
 计时器面板上方的进度条。
 */

import SwiftUI

struct MeetingHeaderView: View {
    let secondsElapsed: Int
    let secondsRemaining: Int
    private var minutesRemaining: Int {
        secondsRemaining / 60
    }
    private var minutesElapsed: Int{
        secondsElapsed / 60
    }
    private var minutesRemainingMetric: String {
        minutesRemaining == 1 ? "minute" : "minutes"
    }
    private var progress: Double {
        guard secondsRemaining > 0 else { return 1 }
        let totalMinutes = Double(minutesElapsed + minutesRemaining)
        return Double(minutesElapsed) / totalMinutes
    }
    let scrumColor: Color

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(ScrumProgressViewStyle(scrumColor: scrumColor))
            HStack {
                VStack(alignment: .leading) {
                    Text("Minutes Elapsed")
                        .font(.caption)
                    Label("\(minutesElapsed)", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Minutes Remaining")
                        .font(.caption)
                    HStack {
                        Text("\(minutesRemaining)")
                        Image(systemName: "hourglass.tophalf.fill")
                    }
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Time remaining"))
        .accessibilityValue(Text("\(minutesRemaining) \(minutesRemainingMetric)"))
        .padding([.top, .horizontal])
    }
}

struct MeetingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingHeaderView(secondsElapsed: 60, secondsRemaining: 180, scrumColor: DailyScrum.data[0].color)
            .previewLayout(.sizeThatFits)
    }
}
