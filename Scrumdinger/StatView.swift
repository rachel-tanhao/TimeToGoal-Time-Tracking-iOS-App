//
//  StatView.swift
//  Scrumdinger
//
//  Created by HuiYu Chen on 2/24/24.
//

import SwiftUI

struct StatView: View {
    let scrum: DailyScrum
    var body: some View {
        VStack(alignment: .leading) {
            Text(scrum.title)
                .font(.headline)
            Spacer()
            HStack {

                Spacer()
                Label("\(scrum.lengthInHours)", systemImage: "clock")
                    .padding(.trailing, 20)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Task length"))
                    .accessibilityValue(Text("\(scrum.lengthInHours) hours"))
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor)
    }
}

struct StatViewPreview: PreviewProvider {
    static var scrum = DailyScrum.data[0]
    static var previews: some View {
        StatView(scrum: scrum)
            .background(scrum.color)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
