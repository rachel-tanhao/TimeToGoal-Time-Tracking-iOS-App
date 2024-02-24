import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data
    @State private var selectedType: String = "work" // Temporary state
    let types = ["work", "health", "study", "custom"] // should come from backend
    @State private var customType: String = "" // State for custom type input
    
    // Define a method to get color based on type
    private func colorForType(type: String) -> Color {
        switch type {
        case "work":
            return Color.blue // Assuming blue is the color for work
        case "health":
            return Color.green // Assuming green is the color for health
        case "study":
            return Color.yellow // Assuming yellow is the color for study
        case "custom":
            return Color.purple // Assuming purple is the color for custom
        default:
            return Color.gray // Default color
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $scrumData.title)
                HStack {
                    Slider(value: $scrumData.lengthInHours, in: 1...30, step: 1.0) {
                        Text("Length")
                    }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInHours)) hours"))
                    Spacer()
                    Text("\(Int(scrumData.lengthInHours)) hours")
                        .accessibilityHidden(true)
                }
                Picker("Type", selection: $selectedType) {
                    ForEach(types, id: \.self) { type in
                        Text(type.capitalized)
                            .foregroundColor(colorForType(type: type)) // Set text color based on type
                    }
                }
                // Add TextField for custom type input if "custom" is selected
                if selectedType == "custom" {
                    TextField("Custom Type", text: $customType)
                        .foregroundColor(colorForType(type: "custom"))
                }
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
