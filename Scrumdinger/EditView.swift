import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data
    
    var body: some View {
        List {
            Section(header: Text("Time To Goal")) {
                TextField("Title", text: $scrumData.title)
                HStack {
                    Slider(value: $scrumData.lengthInHours, in: 1...8, step: 1.0) {
                        Text("Length")
                    }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInHours)) hours"))
                    Spacer()
                    Text("\(Int(scrumData.lengthInHours)) hours")
                        .accessibilityHidden(true)
                }
                ColorPicker("Color", selection: $scrumData.color)
                    .accessibilityLabel(Text("Color picker"))

            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(scrumData: .constant(DailyScrum.data[0].data))
    }
}
