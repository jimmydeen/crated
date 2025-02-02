import SwiftUI
import Kingfisher

struct HomeView: View {
    @Environment(Authentication.self) private var auth
    
    @State var contextAlbum: Album?
    @State var contextPosition = CGPointZero
    
    @State private var contextOnAppearAction = false
    @State private var viewModel = HomeViewModel()
    
    private let contextAnimationDuration: CGFloat = 0.2
    private let contextFinalPosition = CGPoint(
        x: UIScreen.main.bounds.width * 0.5,
        y: UIScreen.main.bounds.height * 0.3
    )
    private let signInCardHeight: CGFloat = 200
    private let signInCardImageOffsetVertical: CGFloat = -16
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        if !auth.isLoggedIn {
                            signInCard
                        }
                        
                        newestReleases
                    }
                }
                
                if contextAlbum != nil {
                    contextCard
                }
            }
            .task {
                await viewModel.fetchNewReleases()
            }
        }
    }
    
    var signInCard: some View {
        NavigationLink(destination: AccountView()) {
            ZStack {
                Image("accountpromptbg")
                    .resizable()
                    .scaledToFill()
                    .offset(y: signInCardImageOffsetVertical)
                    .frame(height: signInCardHeight)
                    .clipped()
                    .cornerRadius(.standard)
                
                Text("Sign In")
                    .padding(.horizontal, .standard)
                    .padding(.vertical, .small)
                    .background(.white)
                    .cornerRadius(.standard)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, .standard)
        .padding(.bottom, .extraHuge)
    }
    var newestReleases: some View {
        VStack(alignment: .leading) {
            Subtitle(text: "Newest releases")
                .padding(.leading, .standard)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Spacing.standard.rawValue) {
                    ForEach(viewModel.albums, id: \.id) { album in
                        HomeAlbumView(
                            contextAlbum: $contextAlbum,
                            contextPosition: $contextPosition,
                            album: album
                        )
                    }
                }
                .padding(.horizontal, .standard)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    var contextCard: some View {
        ZStack {
            BackgroundBlurView()
                .onTapGesture {
                    withAnimation(.easeOut(duration: contextAnimationDuration)) {
                        contextOnAppearAction = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + contextAnimationDuration) {
                        contextAlbum = nil
                    }
                }
            
            KFImage(contextAlbum!.cover_hq)
                .boxSize(contextOnAppearAction ? .huge : .large)
                .position(contextOnAppearAction ? contextFinalPosition : contextPosition)
                .onAppear {
                    withAnimation {
                        contextOnAppearAction = true
                    }
                }
        }
        .ignoresSafeArea(.all)
    }
}

struct HomeAlbumView: View {
    @State private var changeNotifier: Bool = false
    
    @Binding var contextAlbum: Album?
    @Binding var contextPosition: CGPoint
    
    let album: Album
    
    private let animationDuration: CGFloat = 0.2
    private let pressDuration: CGFloat = 0.5
    
    var body: some View {
        NavigationLink(destination: AlbumView(viewModel: AlbumViewModel(album: album))) {
            KFImage(album.cover_hq)
                .boxSize(.large)
                .opacity(contextAlbum == album ? 0 : 1)
        }
        .disabled(contextAlbum == album)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: pressDuration)
                .onEnded { _ in
                    changeNotifier.toggle()
                    contextAlbum = album
                }
        )
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: changeNotifier) {
                        let frame = geometry.frame(in: .global)
                        contextPosition = CGPoint(x: frame.midX, y: frame.midY)
                    }
            }
        )
    }
}

struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(Authentication())
            .previewDisplayName("Home (Signed Out)")
            .onAppear { Test.ensureSignedOut() }
        
        HomeView()
            .environment(Authentication())
            .previewDisplayName("Home (Signed In)")
            .task { await Test.signInToTestAccount() }
    }
}
