import SwiftUI

struct ActivityView: View {
    @State var viewModel = ActivityViewModel()
    
    private let activityCornerRadius: CGFloat = 12
    private let activityPadding: CGFloat = 6
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.activities, id: \.id) { activity in
                        HStack(spacing: 0) {
                            Text(activity.description)
                                .font(.subheadline)
                            
                            Spacer()
                        }
                        .padding(activityPadding)
                        .background(Color.lightGray)
                        .cornerRadius(activityCornerRadius)
                    }
                }
            }
            .navigationTitle("Activity")
            .task {
                await viewModel.fetchActivities()
            }
        }
    }
}

struct ActivityViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(UserViewModel())
    }
}
