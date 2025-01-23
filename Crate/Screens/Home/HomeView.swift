import SwiftUI
import Kingfisher

struct HomeView: View {
    @State var contextAlbum: AlbumModel?
    @State var contextPosition = CGPointZero
    @State var isDisplayingContext = false
    @State var isDisplayingGradient = false
    
    @State private var auxiliaryContextDisplay = false
    @State private var viewModel = HomeViewModel()
    
    private let albumSize: CGFloat = UIScreen.main.bounds.width * 0.286
    private let albumSpacing: CGFloat = UIScreen.main.bounds.width * 0.0286
    private let BackgroundBlurViewScaling: CGFloat = 1.2
    private let contextExitAnimationDuration: CGFloat = 0.2
    private let contextFinalPosition = CGPoint(
        x: UIScreen.main.bounds.width * 0.5,
        y: UIScreen.main.bounds.height * 0.3
    )
    private let contextScalingFactor: CGFloat = 1.75
    private let gradientAnimationDuration: CGFloat = 2.0
    private let gradientOpacity: CGFloat = 1
    private let userButtonCornerRadius: CGFloat = 24
    private let userButtonPaddingHorizontal: CGFloat = 20
    private let userButtonPaddingVertical: CGFloat = 10
    private let userMarqueeCornerRadius: CGFloat = 12
    private let userMarqueeFrameHeight: CGFloat = 200
    private let userMarqueeFrameWidth: CGFloat = UIScreen.main.bounds.width - 22
    private let userMarqueeOffsetVertical: CGFloat = -16
    private let userMarqueePaddingBottom: CGFloat = 40
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        if !viewModel.isAuthenticated {
                            NavigationLink(destination: AccountView()) {
                                ZStack {
                                    Image("accountpromptbg")
                                        .resizable()
                                        .scaledToFill()
                                        .offset(y: userMarqueeOffsetVertical)
                                        .frame(
                                            width: userMarqueeFrameWidth,
                                            height: userMarqueeFrameHeight
                                        )
                                        .clipped()
                                        .cornerRadius(userMarqueeCornerRadius)
                                    
                                    Text("Sign In")
                                        .padding(.vertical, userButtonPaddingVertical)
                                        .padding(.horizontal, userButtonPaddingHorizontal)
                                        .background(Color.white)
                                        .cornerRadius(userButtonCornerRadius)
                                        .foregroundColor(Color.black)
                                }
                            }
                            .padding(.horizontal, albumSpacing)
                            .padding(.bottom, userMarqueePaddingBottom)
                        }
                        
                        HStack {
                            Text("Newest releases")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.leading, albumSpacing)
                        .padding(.bottom, albumSpacing)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 0) {
                                if viewModel.albums.isEmpty {
                                    ForEach(1...6, id: \.self) { _ in
                                        HomeAlbumPlaceholderView()
                                            .frame(width: albumSize, height: albumSize)
                                            .padding(.leading, albumSpacing)
                                    }
                                } else {
                                    ForEach(viewModel.albums, id: \.id) { album in
                                        HomeAlbumView(
                                            contextAlbum: $contextAlbum,
                                            contextPosition: $contextPosition,
                                            isDisplayingContext: $isDisplayingContext,
                                            album: album
                                        )
                                        .frame(width: albumSize, height: albumSize)
                                        .padding(.leading, albumSpacing)
                                    }
                                }
                            }
                            .padding(.trailing, albumSpacing)
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                    }
                }
                
                if isDisplayingContext {
                    ZStack {
                        VStack {
                            if let gradient = viewModel.gradient {
                                LinearGradient(
                                    gradient: gradient,
                                    startPoint: .top,
                                    endPoint: .center
                                )
                                .opacity(gradientOpacity)
                                .transition(.opacity)
                            }
                        }
                        .ignoresSafeArea(.all)
                        
                        BackgroundBlurView()
                            .scaleEffect(auxiliaryContextDisplay ? BackgroundBlurViewScaling : 1)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: contextExitAnimationDuration)) {
                                    auxiliaryContextDisplay = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + contextExitAnimationDuration) {
                                    isDisplayingGradient = false
                                    isDisplayingContext = false
                                    contextAlbum = nil
                                }
                            }
                            .ignoresSafeArea(.all)
                        
                        KFImage(contextAlbum!.cover_hq)
                            .resizable()
                            .frame(
                                width: albumSize * (auxiliaryContextDisplay ? contextMenuScalingFactor : 1),
                                height: albumSize * (auxiliaryContextDisplay ? contextMenuScalingFactor : 1)
                            )
                            .position(contextMenuPosition)
                            .onAppear {
                                withAnimation {
                                    auxiliaryContextDisplay = true
                                }
                            }
                            .ignoresSafeArea(.all)
                    }
                }
            }
            .onAppear {
                if viewModel.albums.count == 0 {
                    Task {
                        await viewModel.fetchNewReleases()
                    }
                }
            }
        }
    }
    
    private var contextMenuPosition: CGPoint {
        if auxiliaryContextDisplay {
            return CGPoint(
                x: contextFinalPosition.x,
                y: contextFinalPosition.y
            )
        } else {
            return CGPoint(
                x: contextPosition.x + (albumSize / 2),
                y: contextPosition.y + (albumSize / 2)
            )
        }
    }
    private var contextMenuScalingFactor: CGFloat {
        if auxiliaryContextDisplay {
            return contextScalingFactor
        } else {
            return 1
        }
    }
}

struct HomeAlbumView: View {
    @State private var changeNotifier: Bool = false
    
    @Binding var contextAlbum: AlbumModel?
    @Binding var contextPosition: CGPoint
    @Binding var isDisplayingContext: Bool
    
    let album: AlbumModel
    
    private let animationDuration: CGFloat = 0.2
    private let pressDuration: CGFloat = 0.5
    
    var body: some View {
        NavigationLink(destination: AlbumView(album: album)) {
            KFImage(album.cover_hq)
                .resizable()
                .opacity(contextAlbum?.id == album.id ? 0 : 1)
        }
        .disabled(isDisplayingContext)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: pressDuration)
                .onEnded { _ in
                    contextAlbum = album
                    changeNotifier.toggle()
                    
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        isDisplayingContext = true
                    }
                }
        )
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: changeNotifier) {
                        if contextAlbum?.id == album.id {
                            let frame = geometry.frame(in: .global)
                            contextPosition = CGPoint(x: frame.minX, y: frame.minY)
                        }
                    }
            }
        )
    }
}

struct HomeAlbumPlaceholderView: View {
    @State private var animate = false

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.lightGray.opacity(0.8),
                        Color.lightGray.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .scaleEffect(animate ? 1.03 : 0.97)
            .animation(
                .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(DisplayViewModel())
    }
}
