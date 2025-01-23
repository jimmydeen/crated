import SwiftUI
import Kingfisher

struct AddReviewView: View {
    @State var viewModel = AddReviewViewModel()
    
    private let buttonPaddingHorizontal: CGFloat = 6
    private let buttonPaddingVertical: CGFloat = 12
    private let buttonCornerRadius: CGFloat = 12
    private let editCoverSize: CGFloat = 48
    private let headerPaddingBottom: CGFloat = 8
    private let headerPaddingLeading: CGFloat = 20
    private let headerPaddingTop: CGFloat = 36
    private let reviewCornerRadius: CGFloat = 24
    private let reviewHeightCondensed: CGFloat = UIScreen.main.bounds.height * 0.4
    private let reviewHeightExpanded: CGFloat = UIScreen.main.bounds.height * 0.7
    private let searchResultCornerRadius: CGFloat = 8
    private let searchResultCoverSize: CGFloat = UIScreen.main.bounds.width * 0.24
    private let searchResultPadding: CGFloat = 8
    private let searchResultSpacing: CGFloat = 6
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                if viewModel.isAuthenticated {
                    reviewHeader
                    reviewBody
                } else {
                    VStack {
                        Spacer()
                        
                        NavigationLink(destination: AccountView()) {
                            Text("Sign in to review")
                        }
                        .padding(.horizontal, buttonPaddingHorizontal)
                        .padding(.vertical, buttonPaddingVertical)
                        .foregroundColor(.black)
                        .background(Color.lightGray)
                        .cornerRadius(buttonCornerRadius)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: reviewHeight)
                }
            }
            .frame(height: reviewHeight)
            .padding()
            .background(Color.white)
            .clipShape(
                .rect(
                    topLeadingRadius: reviewCornerRadius,
                    topTrailingRadius: reviewCornerRadius
                )
            )
        }
    }
    
    private var reviewHeader: some View {
        HStack {
            if viewModel.tab != .search {
                Button(
                    action: {
                        if viewModel.tab == .publish {
                            viewModel.tab = .edit
                        } else {
                            viewModel.tab = .search
                        }
                    },
                    label: {
                        Image(systemName: "arrow.left")
                    }
                )
            }
            
            Text("New Review")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
        }
    }
    
    @ViewBuilder private var reviewBody: some View {
        switch viewModel.tab {
            case .search: searchBody
            case .edit: editBody
            case .publish: publishBody
        }
    }
    
    private var searchBody: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(Array(viewModel.albums.enumerated()), id: \.offset) { n, album in
                    if n > 0, n % 20 == 0 {
                        searchResult(result: album)
                            .task {
                                await viewModel.fetchResults()
                            }
                    } else {
                        searchResult(result: album)
                    }
                }
            }
        }
    }
    
    private func searchResult(result: SearchResult) -> some View {
        HStack(alignment: .center) {
            KFImage(result.cover_hq)
                .resizable()
                .placeholder {
                    PlaceholderView()
                }
                .frame(width: searchResultCoverSize)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(result.name)
                
                if !result.subtitle.isEmpty {
                    Spacer()
                        .frame(height: searchResultSpacing)
                    
                    Text(result.subtitle)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .font(.subheadline)
            
            Spacer()
        }
        .frame(height: searchResultCoverSize)
        .padding(searchResultPadding)
        .background(Color.lightGray)
        .cornerRadius(searchResultCornerRadius)
    }
    
    private var editBody: some View {
        VStack {
            HStack {
                KFImage(viewModel.album!.cover_hq)
                    .resizable()
                    .placeholder {
                        PlaceholderView()
                    }
                    .frame(width: editCoverSize, height: editCoverSize)
                
                VStack(alignment: .leading) {
                    Text(viewModel.album!.name)
                    
                    Text(viewModel.album!.artists.joined(separator: ", "))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }

            TextEditor(text: $viewModel.title)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            TextEditor(text: $viewModel.description)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Spacer()
                
                Button("Next") { viewModel.tab = .publish }
                    .padding(.horizontal, buttonPaddingHorizontal)
                    .padding(.vertical, buttonPaddingVertical)
                    .foregroundColor(.black)
                    .background(Color.lightGray)
                    .cornerRadius(buttonCornerRadius)
            }
        }
    }
    
    private var publishBody: some View {
        VStack {
            HStack {
                
            }
        }
    }
    
    private var reviewHeight: CGFloat {
        if viewModel.query == "" {
            return reviewHeightCondensed
        } else {
            return reviewHeightExpanded
        }
    }
}

struct AddReviewViewPreview: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(DisplayViewModel())
    }
}
