import SwiftUI

enum ActivityType {
    case AlbumRating
    case AlbumReview
    case FavoriteAdd
    case FavoriteRemove
    case FriendAdded
}

struct ActivityView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    
    private let titlePaddingTop: CGFloat = 84
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Activity")
                    
                    Spacer()
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, titlePaddingTop)
                
                VStack(alignment: .leading) {
                    ForEach(Array(userViewModel.activities), id: \.id) { activity in
                        HStack(spacing: 0) {
                            Text("\(activityText(for: activity))")
                                .font(.subheadline)
                            
                            Spacer()
                        }
                        .padding(6)
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func activityText(for activity: ActivityModel) -> String {
        let userText = activity.username == userViewModel.user!.name ? "You" : activity.username
        let userPronoun = activity.username == userViewModel.user!.name ? "your" : "their"
        
        switch activity.type {
            case.AlbumRating:
                let repetitionCount = Int(floor(activity.rating!))
                return "\(userText) rated \(activity.album?.name ?? "") \(String(repeating: "★", count: repetitionCount))\(activity.rating! == Double(repetitionCount) ? "" : "½")."
            case.AlbumReview: return "\(userText) reviewed \(activity.album?.name ?? "")"
            case.FavoriteAdd: return "\(userText) added \(activity.album?.name ?? "") to \(userPronoun) favorites."
            case.FavoriteRemove: return "\(userText) removed \(activity.album?.name ?? "") from \(userPronoun) favorites."
            case.FriendAdded: return "You became friends with \(activity.username)"
        }
    }
}

struct ActivityViewPreview: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared
        @State var userViewModel = CommonUserViewModel(context: persistenceController.container.viewContext)
        
        ContentView()
            .environment(userViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
