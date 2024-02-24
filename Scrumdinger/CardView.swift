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
                Spacer()
                HStack {
                    Label("\(scrum.attendees.count)", systemImage: "person.3")
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Attendees"))
                        .accessibilityValue(Text("\(scrum.attendees.count)"))
                    Spacer()
                    Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                        .padding(.trailing, 20)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Meeting length"))
                        .accessibilityValue(Text("\(scrum.lengthInMinutes) minutes"))
                }
                .font(.caption)
            }
            .padding()
            .contentShape(Rectangle()) // Makes the entire VStack tappable
            .onTapGesture {
                navigateToDetail()
            }
            
            // button to start timer
            Button(action: navigateToMeeting) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.headline) // Adjust the icon size
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color(red: 0.5, green: 0.8, blue: 0.5)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                // .shadow(radius: 10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()

            
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
