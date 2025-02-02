import SwiftUI
import Kingfisher

struct HorizontalCarouselView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Spacing.standard.rawValue) {
                ForEach(data, id: \.id) { element in
                    content(element)
                }
            }
            .padding(.horizontal, .standard)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

struct ResultListRowView: View {
    let result: SearchResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("")
            
            if let user = result as? User {
                if let cover = user.cover {
                    KFImage(cover)
                        .boxSize(.standard)
                        .padding(.trailing, .standard)
                } else {
                    PlaceholderProfilePictureView()
                        .boxSize(.standard)
                        .padding(.trailing, .standard)
                }
            } else {
                KFImage(result.cover)
                    .boxSize(.standard)
                    .padding(.trailing, .standard)
            }
            
            VStack(alignment: .leading) {
                Text(result.name)
                    .font(.callout)
                    .lineLimit(1)
                
                if let subtitle = result.subtitle {
                    Text(subtitle)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
    }
}
