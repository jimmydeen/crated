import SwiftUI

struct ActivityView: View {
    @Environment(SharedUserViewModel.self) private var userViewModel
    @State var viewModel: ActivityViewModel =  ActivityViewModel()
    
    var body: some View {
        VStack {
            Text("Activity")
            
            Spacer()
        }
    }
}

struct ActivityViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()
        
        ContentView()
            .environment(userViewModel)
    }
}
