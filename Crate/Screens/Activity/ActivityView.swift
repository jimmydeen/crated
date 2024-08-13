import SwiftUI

struct ActivityView: View {
    @State var viewModel: ActivityViewModel =  ActivityViewModel()
    
    var body: some View {
        VStack {
            Text("Activity")
            Spacer()
        }
    }
}
