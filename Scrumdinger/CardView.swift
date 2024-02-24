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
            
            // task details
            VStack(alignment: .leading) {
                Text(scrum.title)
                    .font(.headline)
                    .padding(.bottom, 2)
                HStack {
                    Image(systemName: "clock") // System image for the clock
                    Text("\(scrum.lengthInMinutes) mins to goal") // Here, "mins" is added directly to the text
                    Spacer()
                }
                .font(.caption)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                navigateToDetail()
            }
            
            // timer button
            Button(action: navigateToMeeting) {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.green)
                    .cornerRadius(17)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(10)
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
