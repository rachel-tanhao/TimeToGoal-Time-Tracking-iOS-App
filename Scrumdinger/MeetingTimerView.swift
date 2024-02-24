/*
 计时器面板中间的计时器。
 */

import SwiftUI
let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()
 
struct MeetingTimerView: View {
    var scrumColor: Color
    @State var counter: Int = 0
    var countTo: Int // should use data from our object; seconds

    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .strokeBorder(lineWidth: 24, antialiased: true)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle().trim(from:0, to: progress())
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: 25,
                                    lineCap: .round,
                                    lineJoin:.round
                                )
                            )
                            .foregroundColor(scrumColor.accessibleFontColor)
                            .animation(
                                .easeInOut(duration: 0.2)
                            )
                    )
                 
                Clock(counter: counter, countTo: countTo)
            }
        }.onReceive(timer) { time in
            if (self.counter < self.countTo) {
                self.counter += 1
            }
        }
    }
     
    func completed() -> Bool {
        return progress() == 1
    }
     
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
}
 
struct Clock: View {
    var counter: Int
    var countTo: Int
     
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.system(size: 60))
                .fontWeight(.black)
        }
    }
     
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
         
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}
 
struct MeetingTimerView_Preview: PreviewProvider {
    static var previews: some View {
        MeetingTimerView(scrumColor: Color("Design"), countTo: 120) // placeholder
    }
}
