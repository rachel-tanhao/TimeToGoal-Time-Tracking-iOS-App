/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var attendees: [String]
    var lengthInMinutes: Int
    var lengthInHours: Int
    var transcript: String?

    init(id: UUID = UUID(), date: Date = Date(), attendees: [String], lengthInMinutes: Int, transcript: String? = nil, lengthInHours: Int) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.transcript = transcript
        self.lengthInHours = lengthInHours
    }
}
