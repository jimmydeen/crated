import SwiftUI

struct AddItemView: View {
    @StateObject private var addItemViewModel = AddItemViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if addItemViewModel.results.isEmpty {
                    // TODO: Add empty state for search screen
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(0..<addItemViewModel.results.count, id: \.self) { index in
                                let album = addItemViewModel.results[index] as! AlbumModel
                                if index == addItemViewModel.results.count - 1 {
                                    NavigationLink(destination: AlbumInfoView(album: album)) {
                                        AlbumResultView(album: album)
                                    }
                                    .onAppear {
                                        addItemViewModel.refreshAlbums()
                                    }
                                } else {
                                    NavigationLink(destination: AlbumInfoView(album: album)) {
                                        AlbumResultView(album: album)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
            }
            .navigationTitle("Add Album")
            .searchable(text: $addItemViewModel.query)
        }
    }
}

struct AlbumResultView: View {
    let album: AlbumModel
    
    private let coverSize: CGFloat = 60
    private let resultPaddingExternal: CGFloat = 8
    private let resultPaddingInternal: CGFloat = 16
    private let resultPaddingLeading: CGFloat = 2
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: album.album_image_url_lq)) { phase in
                phase.image?
                    .resizable()
                    .frame(width: coverSize, height: coverSize)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 4)
                    )
            }
            .padding(.leading, resultPaddingLeading)
            
            VStack(alignment: .leading) {
                Text(album.album_name)
                    .padding(.top, resultPaddingInternal)
                    .foregroundColor(.black)
                
                Spacer()
                Text(album.album_artists.joined(separator: ", "))
                    .padding(.bottom, resultPaddingInternal)
                    .foregroundColor(.gray)
            }
            .font(.footnote)
            .frame(height: coverSize)
            .padding(.leading, resultPaddingLeading)
            
            Spacer()
        }
        .padding(resultPaddingExternal)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.12))
        )
        .padding(.horizontal)
    }
}
