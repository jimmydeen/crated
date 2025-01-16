import SwiftUI
import Kingfisher

enum ReviewTab {
    case search, edit, publish
}

struct AddReviewView: View {
    @State var viewModel: AddReviewViewModel
    @State var tab: ReviewTab = .search
    
    private let cornerRadius: CGFloat = 24
    private let frameHeightCondensed: CGFloat = UIScreen.main.bounds.height * 0.4
    private let frameHeightExpanded: CGFloat = UIScreen.main.bounds.height * 0.7
    private let headerPaddingTop: CGFloat = 36
    private let headerPaddingLeading: CGFloat = 20
    private let headerPaddingBottom: CGFloat = 8
    private let spacing: CGFloat = 6
    private let textBoxCornerRadius: CGFloat = 12
    private let textBoxPaddingBottom: CGFloat = 12
    private let textBoxPaddingHorizontal: CGFloat = 6
    private let textBoxPaddingVertical: CGFloat = 6
    private let boxCornerRadius: CGFloat = 8
    private let boxPadding: CGFloat = 8
    private let searchCoverSize: CGFloat = 48
    private let detailsSpacing: CGFloat = 6
    
    private let coverPaddingTrailing: CGFloat = 12
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.24
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                if viewModel.userViewModel.isAuthenticated {
                    reviewHeader
                    reviewBody
                }
            }
            .frame(height: frameHeight)
            .padding()
            .background(Color.white)
            .clipShape(
                .rect(
                    topLeadingRadius: cornerRadius,
                    topTrailingRadius: cornerRadius
                )
            )
        }
    }
    
    private var reviewHeader: some View {
        HStack {
            if tab != .search {
                Button(
                    action: {
                        if tab == .publish {
                            tab = .edit
                        } else {
                            tab = .search
                        }
                    },
                    label: {
                        Image(systemName: "arrow.left")
                    }
                )
            }
            
            Text("New Review")
            
            Spacer()
        }
        .font(.title)
        .fontWeight(.bold)
        .padding(.top, headerPaddingTop)
        .padding(.leading, headerPaddingLeading)
        .padding(.bottom, headerPaddingBottom)
    }
    
    @ViewBuilder private var reviewBody: some View {
        switch tab {
            case .search: searchBody
            case .edit: editBody
            case .publish: publishBody
        }
    }
    
    private var searchBody: some View {
        VStack(spacing: 0) {
            HStack(spacing: spacing) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                ZStack {
                    if viewModel.searchViewModel.query.isEmpty {
                        HStack {
                            Text("Search")
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                    }
                    
                    HStack {
                        TextField("", text: $viewModel.searchViewModel.query)
                            .autocapitalization(.none)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, textBoxPaddingHorizontal)
            .padding(.vertical, textBoxPaddingVertical)
            .background(Color.lightGray)
            .cornerRadius(textBoxCornerRadius)
            .padding(.horizontal)
            .padding(.bottom, textBoxPaddingBottom)
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.searchViewModel.results, id: \.id) { result in
                        Button(
                            action: {
                                viewModel.currentlyReviewedAlbum = result as? AlbumModel
                                tab = .edit
                            },
                            label: {
                                searchResult(result: result)
                            }
                        )
                        .if(result.id == viewModel.searchViewModel.results.last?.id) { view in
                            view.task {
                                await viewModel.searchViewModel.fetchResults()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func searchResult(result: ResultProtocol) -> some View {
        HStack(alignment: .center) {
            KFImage(result.cover_hq)
                .resizable()
                .placeholder {
                    PlaceholderView()
                }
                .frame(width: searchCoverSize, height: searchCoverSize)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(result.name)
                
                if !result.artists.isEmpty {
                    Spacer()
                        .frame(height: detailsSpacing)
                    
                    Text(result.artists.joined(separator: ", "))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .frame(height: coverSize)
            .font(.subheadline)
            
            Spacer()
        }
        .padding(boxPadding)
        .background(Color.lightGray)
        .cornerRadius(boxCornerRadius)
    }
    
    private var editBody: some View {
        VStack {
            if let album = viewModel.currentlyReviewedAlbum {
                HStack {
                    KFImage(album.cover_hq)
                        .resizable()
                        .placeholder {
                            PlaceholderView()
                        }
                        .frame(width: coverSize, height: coverSize)
                        .padding(.trailing, coverPaddingTrailing)
                    
                    VStack(alignment: .leading) {
                        Text(album.name)
                        
                        Text(album.artists.joined(separator: ", "))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: spacing) {
                    ZStack {
                        if viewModel.newReviewTitle.isEmpty {
                            HStack {
                                Text("Title")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                        }
                        
                        HStack {
                            TextField("", text: $viewModel.newReviewTitle)
                                .autocapitalization(.none)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, textBoxPaddingHorizontal)
                .padding(.vertical, textBoxPaddingVertical)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .padding(.bottom, textBoxPaddingBottom)
                
                HStack(spacing: spacing) {
                    ZStack {
                        if viewModel.newReviewDescription.isEmpty {
                            HStack {
                                Text("Description")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                        }
                        
                        HStack {
                            TextField("", text: $viewModel.newReviewDescription)
                                .autocapitalization(.none)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, textBoxPaddingHorizontal)
                .padding(.vertical, textBoxPaddingVertical)
                .background(Color.lightGray)
                .cornerRadius(textBoxCornerRadius)
                .padding(.bottom, textBoxPaddingBottom)
                
                HStack {
                    Button(action: {
                        tab = .publish
                    }) {
                        Text("Next")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(cornerRadius)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
    private var publishBody: some View {
        VStack {
            HStack {
                
            }
        }
    }
    
    private var frameHeight: CGFloat {
        if viewModel.searchViewModel.query == "" {
            return frameHeightCondensed
        } else {
            return frameHeightExpanded
        }
    }
}

struct ReviewViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(UserViewModel())
    }
}
