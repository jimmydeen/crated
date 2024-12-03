import SwiftUI

enum ActivityType {
    case AlbumRating
    case AlbumReview
    case FavoriteAdd
    case FavoriteRemove
    case FriendAdded
}

struct ActivityEventView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    
    let activity: ActivityModel
    
    private let activityPadding: CGFloat = 6
    
    var body: some View {
        HStack(spacing: 0) {
            Text(self.activityText)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(self.activityPadding)
        .background(Colors.lightGray)
    }
    
    private var activityText: String {
        let userText = activity.username == self.userViewModel.user!.name ? "You" : activity.username
        let userPronoun = activity.username == self.userViewModel.user!.name ? "your" : "their"
        
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

struct ActivityView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    
    private let paddingTop: CGFloat = 84
    private let titlePaddingBottom: CGFloat = 6
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Activity")
                    
                    Spacer()
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, self.titlePaddingBottom)
                
                VStack(alignment: .leading) {
                    ForEach(Array(self.userViewModel.activities), id: \.id) { activity in
                        ActivityEventView(activity: activity)
                    }
                }
            }
            .padding(.top, self.paddingTop)
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct ActivityViewPreview: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared
        @State var displayViewModel = CommonDisplayViewModel()
        @State var userViewModel = CommonUserViewModel(context: persistenceController.container.viewContext)
        
        TabsView()
            .environment(displayViewModel)
            .environment(userViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .ignoresSafeArea(.all)
    }
}
