import SwiftUI
import Kingfisher

struct ListView: View {
    @State var viewModel: ListViewModel
    @State var isRenaming: Bool = false
    @State var isSharing: Bool = false
    
    init(list: ListModel) {
        _viewModel = State(wrappedValue: ListViewModel(list: list))
    }
    
    private let indexPaddingLeading: CGFloat = 6
    private let shareCoverSize: CGFloat = UIScreen.main.bounds.width * 0.5
    private let trackCornerRadius: CGFloat = 12
    private let trackCoverSize: CGFloat = UIScreen.main.bounds.width * 0.14
    private let trackElementSpacing: CGFloat = 12
    private let trackPaddingHorizontal: CGFloat = 18
    private let trackPaddingInternal: CGFloat = 12
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.list.name)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        settingsDropDown
                    }
                    .font(.largeTitle)
                    .padding(.horizontal)
                    
                    ForEach(Array(viewModel.albums.enumerated()), id: \.element.id) { index, album in
                        NavigationLink(destination: AlbumView(album: album)) {
                            listItem(album: album, index: index + 1)
                        }
                    }
                    
                    Spacer()
                }
            }
            
            if isSharing {
                shareScreen
            }
        }
        .task {
            await viewModel.fetchAlbums()
        }
    }
    
    private func listItem(album: AlbumModel, index: Int) -> some View {
        HStack(alignment: .center, spacing: trackElementSpacing) {
            Text("\(index)")
                .padding(.leading, indexPaddingLeading)
            
            KFImage(album.cover_hq)
                .placeholder {
                    PlaceholderView()
                }
                .resizable()
                .frame(width: trackCoverSize, height: trackCoverSize)
            
            VStack(alignment: .leading) {
                Text(album.name)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text(album.artists.joined(separator: ", "))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(trackPaddingInternal)
        .background(Color.lightGray)
        .cornerRadius(trackCornerRadius)
        .padding(.horizontal, trackPaddingHorizontal)
    }
    
    private var settingsDropDown: some View {
        Menu {
            Button(action: {
                isRenaming = true
            }) {
                Label("Rename", systemImage: "pencil")
            }
            Button(action: {
                isSharing = true
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    private var shareScreen: some View {
        ZStack {
            BackgroundBlurView()
                .onTapGesture {
                    isSharing = false
                }
            
            if viewModel.list.albums.count > 2 {
                shareScreenCover(url: viewModel.albums[2].cover_hq!)
                shareScreenCover(url: viewModel.albums[1].cover_hq!)
                shareScreenCover(url: viewModel.albums[0].cover_hq!)
            } else if viewModel.list.albums.count > 1 {
                shareScreenCover(url: viewModel.albums[1].cover_hq!)
                shareScreenCover(url: viewModel.albums[0].cover_hq!)
            } else {
                shareScreenCover(url: viewModel.albums[0].cover_hq!)
            }
        }
    }
    
    private func shareScreenCover(url: URL) -> some View {
        KFImage(url)
            .resizable()
            .frame(width: shareCoverSize, height: shareCoverSize)
    }
}

struct ListViewPreview: PreviewProvider {
    static var previews: some View {
        ListView(list: MockData.list)
            .environment(DisplayViewModel())
    }
}
