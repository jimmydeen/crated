import SwiftUI

struct AddListItemView: View {
    @State var viewModel: AddListViewModel
    
    var body: some View {
        Text("Five")
    }
}

struct AddListItemViewPreview: PreviewProvider {
    static var previews: some View {
        AddListItemView(viewModel: AddListViewModel())
            .environment(DisplayViewModel())
    }
}
