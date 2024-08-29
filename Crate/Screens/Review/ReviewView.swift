import SwiftUI

struct NewReviewView: View {
    @Environment(SharedUserViewModel.self) private var userViewModel
    @State var searchViewModel: SearchViewModel = SearchViewModel()
    @State var viewModel: NewReviewViewModel = NewReviewViewModel()
    
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
                                Image(systemName: "multiply")
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
                
                if !viewModel.isCreatingReview {
                    VStack(spacing: 0) {
                        HStack(spacing: 6) {
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
                                ForEach(searchViewModel.results, id: \.id) { result in
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
                                                    if result.id == searchViewModel.results.last?.id {
                                                        Task {
                                                            await searchViewModel.fetchResults()
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
                        HStack(spacing: 6) {
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
                        
                        HStack(spacing: 6) {
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
                        
                        Spacer()
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(height: currentFrameSize)
            .background(
                VStack {
                    Spacer()
                    
                    UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12, style: .circular)
                        .fill(.white)
                        .frame(height: currentFrameSize)
                }
            )
        }
    }
    
    private var currentFrameSize: CGFloat {
        if searchViewModel.query == "" {
            return UIScreen.main.bounds.height * 0.4
        } else {
            return UIScreen.main.bounds.height * 0.7
        }
    }
}

struct NewReviewViewPreview: PreviewProvider {
    static var previews: some View {
        @State var userViewModel = SharedUserViewModel()

        ContentView()
            .environment(userViewModel)
    }
}
