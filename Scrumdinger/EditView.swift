import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data
    @State private var selectedCategory: String = "work" // Temporary state, changed from selectedType
    let categories = ["work", "health", "study", "custom"] // should come from backend, changed from types
    @State private var customCategory: String = "" // State for custom category input, changed from customType
    
    // Define a method to get color based on category
    private func colorForCategory(category: String) -> Color {
        switch category {
        case "work":
            return Color.blue
        case "health":
            return Color.green
        case "study":
            return Color.yellow
        case "custom":
            return Color.purple
        default:
            return Color.gray
        }
    }
    
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
                Picker("Category", selection: $selectedCategory) { // Changed from "Type" to "Category"
                    ForEach(categories, id: \.self) { category in
                        Text(category.capitalized)
                            .foregroundColor(colorForCategory(category: category))
                    }
                }

                if selectedCategory == "custom" {
                    TextField("Custom Category", text: $customCategory)
                        .foregroundColor(colorForCategory(category: "custom"))
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
