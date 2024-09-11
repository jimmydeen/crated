import Foundation
import SwiftUI
import Kingfisher

struct ListItemView: View {
    @Binding var isDisplayingAlbum: Bool
    @Binding var selectedAlbum: AlbumModel?
    let index: Int
    let album: AlbumModel
    
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.14
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("\(index + 1)")
                .padding(.leading, 6)
            
            KFImage(URL(string: album.image_url_hq ?? ""))
                .placeholder {
                    CommonImagePlaceholderView()
                }
                .resizable()
                .frame(
                    width: coverSize,
                    height: coverSize
                )
            
            VStack(alignment: .leading) {
                Text(album.name)
                    .foregroundColor(.black)
                
                Text(album.artists.joined(separator: ", "))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.trailing, 12)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Colors.lightGray)
        }
        .onTapGesture {
            self.selectedAlbum = album
            withAnimation {
                self.isDisplayingAlbum = true
            }
        }
        .simultaneousGesture(
            DragGesture()
        )
        .padding(.trailing, 9)
    }
}

struct ListView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var isDisplayingAlbum: Bool = false
    @State var isShowingEdit: Bool = false
    @State var isShowingSettings: Bool = false
    @State var selectedAlbum: AlbumModel?
    @Binding var displayBinding: Bool
    
    var list: ListModel
    
    private let backButtonSpacing: CGFloat = 5
    private let elementSpacing: CGFloat = 6
    private let titlePaddingTop: CGFloat = 84
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: elementSpacing) {
                    Button(
                        action: {
                            withAnimation {
                                self.displayBinding = false
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
                    .padding(.bottom, 6)
                    
                    HStack(alignment: .center) {
                        Text(list.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(
                            action: {
                                self.isShowingEdit = true
                            },
                            label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
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
                    .padding(.trailing, 32)
                    .padding(.bottom, 6)
                    
                    ForEach(Array(self.list.albums.enumerated()), id: \.element.id) { index, album in
                        ListItemView(
                            isDisplayingAlbum: $isDisplayingAlbum,
                            selectedAlbum: $selectedAlbum,
                            index: index,
                            album: album
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, titlePaddingTop)
                .padding(.horizontal, 18)
                .zIndex(0)
            }
            
            if self.isDisplayingAlbum, let album = self.selectedAlbum {
                AlbumView(
                    album: album,
                    displayBinding: $isDisplayingAlbum,
                    rating: self.userViewModel.ratings[album.id] ?? 0
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
    }
}

struct ListViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
        
        ListView(
            displayBinding: .constant(true),
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
                    )
                ],
                image: ""
            )
        )
        .environment(userViewModel)
        .ignoresSafeArea(.all)
    }
}
