import SwiftUI
import Kingfisher

struct CrateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: CrateViewModel
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Title(text: viewModel.crate.name)
                        
                        Menu {
                            Button(action: {
                                viewModel.deleteCrate()
                                dismiss()
                            }) {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        
                    }
                    
                    RoundedNavButton(text: "Add To Crate", destination: CrateAddView(viewModel: $viewModel))
                    
                    ForEach(Array(viewModel.albums.enumerated()), id: \.element.id) { index, album in
                        NavigationLink(destination: AlbumView(viewModel: AlbumViewModel(album: album))) {
                            crateItem(album: album, index: index)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.standard)
        }
        .task {
            await viewModel.fetchAlbums()
        }
    }
    
    private func crateItem(album: Album, index: Int) -> some View {
        HStack(alignment: .center) {
            Text("\(index + 1)")
                .padding(.leading, .tiny)
            
            KFImage(album.cover_hq)
                .boxSize(.standard)
            
            VStack(alignment: .leading) {
                Text(album.name)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text(album.artists.joined(separator: ", "))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Divider()
            
            Image(systemName: "line.3.horizontal")
        }
        .padding(.standard)
        .background(Color.lightGray)
        .cornerRadius(.standard)
    }
}

struct CrateViewPreviews: PreviewProvider {
    static var previews: some View {
        CrateView(viewModel: CrateViewModel(crate: Test.crate))
            .environment(Authentication())
            .previewDisplayName("Crate (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        CrateView(viewModel: CrateViewModel(crate: Test.crate))
            .environment(Authentication())
            .previewDisplayName("Crate (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
