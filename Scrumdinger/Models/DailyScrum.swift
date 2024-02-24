/*
See LICENSE folder for this sample’s licensing information.
*/
import SwiftUI

struct DailyScrum: Identifiable, Codable {
    let id: UUID
    var title: String
    var attendees: [String]
    var lengthInMinutes: Int
    var color: Color
    var history: [History]
    var durationInMinutes: Int = 0 // Added variable with default value of 0
    var corrTaskId: UUID? // Added optional variable, default to nil

    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, color: Color, history: [History] = [], durationInMinutes: Int = 0, corrTaskId: UUID? = nil) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.color = color
        self.history = history
        self.durationInMinutes = durationInMinutes // Initialize with provided value or default
        self.corrTaskId = corrTaskId // Initialize with provided value or nil
    }
}

extension DailyScrum {
    static var data: [DailyScrum] {
        [
            DailyScrum(title: "根据功能修改前端", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 2, color: Color("Design")),
            DailyScrum(title: "改写后端逻辑、实现功能", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 4, color: Color("App Dev")),
            DailyScrum(title: "调试、打包成APP", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 1, color: Color("Web Dev"))
        ]
    }
}

extension DailyScrum {
    struct Data {
        var title: String = ""
        var attendees: [String] = []
        var lengthInMinutes: Double = 5.0
        var color: Color = .random
    }

    var data: Data {
        return Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), color: color)
    }

    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        color = data.color
    }
}
