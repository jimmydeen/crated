import SwiftUI
import Kingfisher

struct ReviewResultView: View {
    let result: ResultProtocol
    
    private let boxCornerRadius: CGFloat = 8
    private let boxPadding: CGFloat = 8
    private let coverSize: CGFloat = 48
    private let coverSpacingFromDetails: CGFloat = 12
    private let detailsSpacing: CGFloat = 6
    
    var body: some View {
        HStack(alignment: .center) {
            KFImage(result.cover_hq)
                .resizable()
                .placeholder {
                    PlaceholderView()
                }
                .frame(width: coverSize, height: coverSize)
            
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
}

struct ReviewView: View {
    @State var searchViewModel: SearchViewModel = SearchViewModel()
    @State var viewModel: ReviewViewModel = ReviewViewModel()
    
    private let backButtonPaddingTrailing: CGFloat = 4
    private let backButtonOffsetHorizontal: CGFloat = -12
    private let cornerRadius: CGFloat = 24
    private let coverPaddingTrailing: CGFloat = 12
    private let coverSize: CGFloat = UIScreen.main.bounds.width * 0.24
    private let frameHeightCondensed: CGFloat = UIScreen.main.bounds.height * 0.4
    private let frameHeightExpanded: CGFloat = UIScreen.main.bounds.height * 0.7
    private let frameWidth: CGFloat = UIScreen.main.bounds.width
    private let headerPaddingTop: CGFloat = 36
    private let headerPaddingLeading: CGFloat = 20
    private let headerPaddingBottom: CGFloat = 8
    private let spacing: CGFloat = 6
    private let textBoxCornerRadius: CGFloat = 12
    private let textBoxPaddingBottom: CGFloat = 12
    private let textBoxPaddingHorizontal: CGFloat = 6
    private let textBoxPaddingVertical: CGFloat = 6
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                HStack {
                    if viewModel.isCreatingReview {
                        Button(
                            action: {
                                withAnimation {
                                    viewModel.isCreatingReview = false
                                }
                            },
                            label: {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.trailing, backButtonPaddingTrailing)
                            }
                        )
                        .transition(.opacity.combined(with: .offset(x: backButtonOffsetHorizontal)))
                    }
                    
                    Text("New Review")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.top, headerPaddingTop)
                .padding(.leading, headerPaddingLeading)
                .padding(.bottom, headerPaddingBottom)
                
                if !viewModel.isCreatingReview {
                    VStack(spacing: 0) {
                        HStack(spacing: spacing) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            ZStack {
                                if searchViewModel.query.isEmpty {
                                    HStack {
                                        Text("Search")
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                }
                                
                                HStack {
                                    TextField("", text: $searchViewModel.query)
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
                                ForEach(searchViewModel.results, id: \.id) { result in
                                    Button(
                                        action: {
                                            viewModel.currentlyReviewedAlbum = result as? AlbumModel
                                            withAnimation {
                                                viewModel.isCreatingReview = true
                                            }
                                        },
                                        label: {
                                            ReviewResultView(result: result)
                                        }
                                    )
                                    .if(result.id == searchViewModel.results.last?.id) { view in
                                        view.task {
                                            await searchViewModel.fetchResults()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .transition(.move(edge: .leading))
                } else {
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
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(width: frameWidth, height: frameHeight)
            .background(Color.white)
            .cornerRadius(cornerRadius)
        }
    }
    
    private var frameHeight: CGFloat {
        if searchViewModel.query == "" {
            return frameHeightCondensed
        } else {
            return frameHeightExpanded
        }
    }
}

struct ReviewViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .ignoresSafeArea(.all)
    }
}
