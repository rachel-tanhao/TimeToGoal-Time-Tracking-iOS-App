/*
音频transcribe功能，不需要用到。
 */

import SwiftUI

struct HistoryView: View {
    let history: History
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                }
            }
        }
        
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History( lengthInMinutes: 10, lengthInHours: 10) )
    }
}
