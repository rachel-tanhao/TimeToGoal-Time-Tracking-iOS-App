/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation


/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.
class ScrumTimer: ObservableObject {

    @Published var secondsElapsed = 0
    @Published var secondsRemaining = 0

    var lengthInMinutes: Int

    private var timer: Timer?
    private var frequency: TimeInterval { 1.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }


    init(lengthInMinutes: Int = 0) {
        self.lengthInMinutes = lengthInMinutes
        self.secondsRemaining = lengthInSeconds
    }
    
    /// Start the timer.
    func startScrum() {
        secondsElapsed = 0
        secondsRemaining = lengthInSeconds

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.secondsElapsed += 1
            self.secondsRemaining -= 1

            if self.secondsRemaining <= 0 {
                self.timer?.invalidate()
            }
        }
    }
    
    /// Stop the timer.
    func stopScrum() {
        timer?.invalidate()
        timer = nil
    }
  
    func reset(lengthInMinutes: Int) {
        timer?.invalidate()
        self.lengthInMinutes = lengthInMinutes
        self.secondsElapsed = 0
        self.secondsRemaining = lengthInMinutes * 60
    }
}
