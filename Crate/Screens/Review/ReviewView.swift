import SwiftUI
import Kingfisher

struct ReviewView: View {
    @Environment(CommonUserViewModel.self) private var userViewModel
    @State var searchViewModel: SearchViewModel = SearchViewModel()
    @State var viewModel: ReviewViewModel = ReviewViewModel()
    
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
                                Image(systemName: "arrow.back")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 4)
                            }
                        )
                        .transition(.opacity.combined(with: .offset(x: -12)))
                    }
                    
                    Text("New Review")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.top, 36)
                .padding(.leading, 20)
                .padding(.bottom, 8)
                
                if !self.viewModel.isCreatingReview {
                    VStack(spacing: 0) {
                        HStack(spacing: 6) {
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
                        .padding(.horizontal, 6)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.1)))
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                        
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
                                                .onAppear {
                                                    if result.id == self.searchViewModel.results.last?.id {
                                                        Task {
                                                            await self.searchViewModel.fetchResults()
                                                        }
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
                                        CommonImagePlaceholderView()
                                    }
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.24,
                                        height: UIScreen.main.bounds.width * 0.24
                                    )
                                    .padding(.trailing, 12)
                                
                                VStack(alignment: .leading) {
                                    Text(album.name)
                                    
                                    Text(album.artists.joined(separator: ", "))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 6) {
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
                            .padding(.horizontal, 6)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray.opacity(0.1)))
                            .padding(.bottom, 12)
                            
                            HStack(spacing: 6) {
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
                            .padding(.horizontal, 6)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray.opacity(0.1)))
                            .padding(.bottom, 12)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(height: self.currentFrameSize)
            .background(
                VStack {
                    Spacer()
                    
                    UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12, style: .circular)
                        .fill(.white)
                        .frame(height: self.currentFrameSize)
                }
            )
        }
    }
    
    private var currentFrameSize: CGFloat {
        if self.searchViewModel.query == "" {
            return UIScreen.main.bounds.height * 0.4
        } else {
            return UIScreen.main.bounds.height * 0.7
        }
    }
}

struct ReviewViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)

        ContentView()
            .environment(userViewModel)
    }
}
