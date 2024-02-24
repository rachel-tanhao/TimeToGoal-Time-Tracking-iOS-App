/*
 目标卡片面板。(记得点一下预览窗口里左下角第二个箭头按钮)
 */

import SwiftUI

struct CardView: View {
    let scrum: DailyScrum
    var navigateToMeeting: () -> Void
    var navigateToDetail: () -> Void
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(scrum.title)
                    .font(.headline)
                Spacer()
                HStack {
                    Label("\(scrum.attendees.count)", systemImage: "person.3")
                    Spacer()
                    Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                }
                .font(.caption)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                navigateToDetail()
            }
            
            Button(action: navigateToMeeting) {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .foregroundColor(scrum.color.accessibleFontColor)
        .background(scrum.color)
    }
}


struct CardView_Previews: PreviewProvider {
    static var scrum = DailyScrum.data[0]
    static var previews: some View {
        CardView(scrum: scrum, navigateToMeeting: {}, navigateToDetail: {})
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
