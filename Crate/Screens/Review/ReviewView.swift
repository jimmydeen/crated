import SwiftUI
import Kingfisher

struct ReviewView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
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
                    if self.viewModel.isCreatingReview {
                        Button(
                            action: {
                                withAnimation {
                                    self.viewModel.isCreatingReview = false
                                }
                            },
                            label: {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.trailing, self.backButtonPaddingTrailing)
                            }
                        )
                        .transition(.opacity.combined(with: .offset(x: self.backButtonOffsetHorizontal)))
                    }
                    
                    Text("New Review")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.top, self.headerPaddingTop)
                .padding(.leading, self.headerPaddingLeading)
                .padding(.bottom, self.headerPaddingBottom)
                
                if !self.viewModel.isCreatingReview {
                    VStack(spacing: 0) {
                        HStack(spacing: spacing) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            ZStack {
                                if self.searchViewModel.query.isEmpty {
                                    HStack {
                                        Text("Search")
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                }
                                
                                HStack {
                                    TextField("", text: self.$searchViewModel.query)
                                        .autocapitalization(.none)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, self.textBoxPaddingHorizontal)
                        .padding(.vertical, self.textBoxPaddingVertical)
                        .background(Colors.lightGray)
                        .cornerRadius(self.textBoxCornerRadius)
                        .padding(.horizontal)
                        .padding(.bottom, self.textBoxPaddingBottom)
                        
                        ScrollView(showsIndicators: false) {
                            LazyVStack {
                                ForEach(self.searchViewModel.results, id: \.id) { result in
                                    Button(
                                        action: {
                                            self.viewModel.currentlyReviewedAlbum = result as? AlbumModel
                                            withAnimation {
                                                self.viewModel.isCreatingReview = true
                                            }
                                        },
                                        label: {
                                            SearchResultView(result: result)
                                                .if(result.id == self.searchViewModel.results.last?.id) { view in
                                                    view.task {
                                                        await self.searchViewModel.fetchResults()
                                                    }
                                                }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .transition(.move(edge: .leading))
                } else {
                    VStack {
                        if let album = self.viewModel.currentlyReviewedAlbum {
                            HStack {
                                KFImage(URL(string: album.image_url_hq ?? ""))
                                    .resizable()
                                    .placeholder {
                                        CommonPlaceholderView()
                                    }
                                    .frame(width: self.coverSize, height: self.coverSize)
                                    .padding(.trailing, self.coverPaddingTrailing)
                                
                                VStack(alignment: .leading) {
                                    Text(album.name)
                                    
                                    Text(album.artists.joined(separator: ", "))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: self.spacing) {
                                ZStack {
                                    if self.viewModel.newReviewTitle.isEmpty {
                                        HStack {
                                            Text("Title")
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                    HStack {
                                        TextField("", text: self.$viewModel.newReviewTitle)
                                            .autocapitalization(.none)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, self.textBoxPaddingHorizontal)
                            .padding(.vertical, self.textBoxPaddingVertical)
                            .background(Colors.lightGray)
                            .cornerRadius(self.textBoxCornerRadius)
                            .padding(.bottom, self.textBoxPaddingBottom)
                            
                            HStack(spacing: self.spacing) {
                                ZStack {
                                    if self.viewModel.newReviewDescription.isEmpty {
                                        HStack {
                                            Text("Description")
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                    HStack {
                                        TextField("", text: self.$viewModel.newReviewDescription)
                                            .autocapitalization(.none)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, self.textBoxPaddingHorizontal)
                            .padding(.vertical, self.textBoxPaddingVertical)
                            .background(Colors.lightGray)
                            .cornerRadius(self.textBoxCornerRadius)
                            .padding(.bottom, self.textBoxPaddingBottom)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(width: self.frameWidth, height: self.frameHeight)
            .background(Color.white)
            .cornerRadius(self.cornerRadius)
        }
    }
    
    private var frameHeight: CGFloat {
        if self.searchViewModel.query == "" {
            return self.frameHeightCondensed
        } else {
            return self.frameHeightExpanded
        }
    }
}

struct ReviewViewPreview: PreviewProvider {
    static var previews: some View {
        @State var displayViewModel = CommonDisplayViewModel()
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)

        TabsView()
            .environment(displayViewModel)
            .environment(userViewModel)
            .ignoresSafeArea(.all)
    }
}
