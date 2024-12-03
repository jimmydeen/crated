import Foundation
import SwiftUI
import Kingfisher

struct ListItemView: View {
    @Binding var isDisplayingAlbum: Bool
    @Binding var selectedAlbum: AlbumModel?
    
    let index: Int
    let album: AlbumModel
    
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.14
    private let indexPaddingLeading: CGFloat = 6
    private let settingsIndicatorPaddingTrailing: CGFloat = 12
    private let trackViewCornerRadius: CGFloat = 12
    private let trackViewInternalPadding: CGFloat = 12
    private let trackViewPaddingTrailing: CGFloat = 9
    private let verticalElementSpacing: CGFloat = 12
    
    var body: some View {
        HStack(alignment: .center, spacing: self.verticalElementSpacing) {
            Text("\(self.index)")
                .padding(.leading, self.indexPaddingLeading)
            
            KFImage(URL(string: self.album.image_url_hq ?? ""))
                .placeholder {
                    CommonPlaceholderView()
                }
                .resizable()
                .frame(
                    width: self.coverSize,
                    height: self.coverSize
                )
            
            VStack(alignment: .leading) {
                Text(self.album.name)
                    .foregroundColor(.black)
                
                Text(self.album.artists.joined(separator: ", "))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.trailing, self.settingsIndicatorPaddingTrailing)
        }
        .padding(self.trackViewInternalPadding)
        .background {
            RoundedRectangle(cornerRadius: self.trackViewCornerRadius)
                .fill(Colors.lightGray)
        }
        .onTapGesture {
            self.selectedAlbum = self.album
            withAnimation {
                self.isDisplayingAlbum = true
            }
        }
        .padding(.trailing, self.trackViewPaddingTrailing)
    }
}

struct ListView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var viewModel: ListViewModel
    @State var draggedItem: Int?
    @State var isDisplayingAlbum: Bool = false
    @State var isRenaming: Bool = false
    @State var isSharing: Bool = false
    @State var isShowingSettings: Bool = false
    @State var selectedAlbum: AlbumModel?
    @Binding var displayBinding: Bool
    
    init(list: ListModel, displayBinding: Binding<Bool>) {
        _viewModel = State(wrappedValue: ListViewModel(list: list))
        _displayBinding = displayBinding
    }
    
    private let backButtonSpacing: CGFloat = 5
    private let buttonPaddingBottom: CGFloat = 6
    private let elementSpacing: CGFloat = 6
    private let titlePaddingBottom: CGFloat = 6
    private let titlePaddingTop: CGFloat = 84
    private let titlePaddingTrailing: CGFloat = 32
    private let viewPaddingHorizontal: CGFloat = 18
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: self.elementSpacing) {
                    Button(
                        action: {
                            withAnimation {
                                self.displayBinding.toggle()
                            }
                        },
                        label: {
                            HStack(spacing: self.backButtonSpacing) {
                                Image(systemName: "arrow.left")
                                
                                Text("Back")
                            }
                            .fontWeight(.medium)
                        }
                    )
                    .padding(.bottom, self.buttonPaddingBottom)
                    
                    HStack(alignment: .center) {
                        Text(self.viewModel.list.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis")
                            .contextMenu(
                                ContextMenu(
                                    menuItems: {
                                        Button(
                                            action: {
                                                self.isRenaming.toggle()
                                            },
                                            label: {
                                                HStack {
                                                    Image(systemName: "pencil")
                                                    
                                                    Text("Rename")
                                                }
                                            }
                                        )
                                        
                                        Button(
                                            action: {
                                                self.isSharing.toggle()
                                            },
                                            label: {
                                                HStack {
                                                    Image(systemName: "square.and.arrow.up")
                                                    
                                                    Text("Share")
                                                }
                                            }
                                        )
                                        
                                        Button(
                                            action: {
                                                self.displayBinding.toggle()
                                            },
                                            label: {
                                                HStack {
                                                    Image(systemName: "delete.right.fill")
                                                    
                                                    Text("Delete")
                                                }
                                            }
                                        )
                                    }
                                )
                            )
                        
                        Button(
                            action: {
                                self.isShowingSettings = true
                            },
                            label: {
                                Image(systemName: "ellipsis")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        )
                    }
                    .padding(.trailing, self.titlePaddingTrailing)
                    .padding(.bottom, self.titlePaddingBottom)
                    
                    ForEach(Array(self.viewModel.list.albums.enumerated()), id: \.element.id) { index, album in
                        ListItemView(
                            isDisplayingAlbum: self.$isDisplayingAlbum,
                            selectedAlbum: self.$selectedAlbum,
                            index: index + 1,
                            album: album
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, self.titlePaddingTop)
                .padding(.horizontal, self.viewPaddingHorizontal)
            }
            
            if self.isDisplayingAlbum, let album = self.selectedAlbum {
                AlbumView(
                    album: album,
                    displayBinding: self.$isDisplayingAlbum,
                    rating: self.userViewModel.ratings[album.id] ?? 0
                )
                .transition(.move(edge: .trailing))
            }
            
            if self.isSharing {
                ShareListView(viewModel: self.$viewModel)
            }
        }
    }
}

struct ShareListView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @Binding var viewModel: ListViewModel
    
    var body: some View {
        CommonBackgroundBlur()
            .zIndex(0)
        
        VStack {
            Spacer()
            
            ZStack { // Introduce splay animation with delay upon opening the share view.
                if self.viewModel.list.albums.count > 2, let image_url = self.viewModel.list.albums[2].image_url_hq {
                    KFImage(URL(string: image_url))
                }
                
                if self.viewModel.list.albums.count > 1, let image_url = self.viewModel.list.albums[1].image_url_hq {
                    KFImage(URL(string: image_url))
                }
                
                if self.viewModel.list.albums.count > 0, let image_url = self.viewModel.list.albums[0].image_url_hq {
                    KFImage(URL(string: image_url))
                }
            }
            
            HStack {
                // Sharing location icons -> tap to share action
                // Space equally using spacers.
            }
            
            Spacer()
        }
        .zIndex(1)
    }
}

struct ListViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
        
        ListView(
            list: ListModel(
                name: "List Name",
                id: UUID(),
                user_id: UUID(),
                albums: [
                    AlbumModel(
                        name: "More Life",
                        id: "1lXY618HWkwYKJWBRYR4MK",
                        artists: ["Drake"],
                        type: "album",
                        release_date: "2017-03-18",
                        spotify_link: "https://open.spotify.com/album/1lXY618HWkwYKJWBRYR4MK",
                        image_url_hq: "https://i.scdn.co/image/ab67616d0000b2734f0fd9dad63977146e685700",
                        image_url_lq: "https://i.scdn.co/image/ab67616d00001e024f0fd9dad63977146e685700"
                    ),
                    AlbumModel(
                        name: "For All The Dogs Scary Hours Edition",
                        id: "4Q7cRXio6mF2ImVUCcezPO",
                        artists: ["Drake"],
                        type: "album",
                        release_date: "2023-11-17",
                        spotify_link: "https://open.spotify.com/album/4Q7cRXio6mF2ImVUCcezPO",
                        image_url_hq: "https://i.scdn.co/image/ab67616d0000b273e286ee36b4015afa8832356a",
                        image_url_lq: "https://i.scdn.co/image/ab67616d0000b273e286ee36b4015afa8832356a"
                    )
                ],
                image: ""
            ),
            displayBinding: .constant(true)
        )
        .environment(userViewModel)
        .ignoresSafeArea(.all)
    }
}
