import SwiftUI
import Kingfisher

struct HomeView: View {
    @Environment(CommonDisplayViewModel.self) private var displayViewModel
    @Environment(CommonUserViewModel.self) private var userViewModel
    
    @State var album: AlbumModel?
    @State var contextAlbum: AlbumModel?
    @State var contextPosition: CGPoint = CGPointZero
    @State var isDisplayingAlbum: Bool = false
    @State var isDisplayingContext: Bool = false
    @State var isDisplayingGradient: Bool = false
    @State var isDisplayingNewestReleases: Bool = false
    @State var isDisplayingUserMarquee: Bool = true
    
    @State private var albumToggle: Bool = false
    @State private var auxiliaryContextDisplay: Bool = false
    @State private var auxiliaryContextRemoval: Bool = false
    @State private var userMarqueeBackgroundY: CGFloat = -16
    @State private var viewModel: HomeViewModel = HomeViewModel()
    
    @Binding var isShowingBackgroundBlur: Bool
    
    private let albumSize: CGFloat = UIScreen.main.bounds.width * 0.286
    private let albumSpacing: CGFloat = UIScreen.main.bounds.width * 0.0286
    private let backgroundBlurScaling: CGFloat = 1.2
    private let contextArtistsFontSize: CGFloat = 10
    private let contextCornerRadius: CGFloat = 6
    private let contextCoverPaddingBottom: CGFloat = 6
    private let contextDetailsFontSize: CGFloat = 5
    private let contextDetailsPaddingBottom: CGFloat = 18
    private let contextExitAnimationDuration: CGFloat = 0.2
    private let contextFinalPosition = CGPoint(
        x: UIScreen.main.bounds.width * 0.5,
        y: UIScreen.main.bounds.height * 0.3
    )
    private let contextNameFontSize: CGFloat = 12
    private let contextScalingFactor: CGFloat = 1.75
    private let gradientAnimationDuration: CGFloat = 2.0
    private let gradientOpacity: CGFloat = 1
    private let newestReleasesBackButtonPaddingLeading: CGFloat = 4
    private let newestReleasesBackButtonPaddingTrailing: CGFloat = 8
    private let paddingTop: CGFloat = 60
    private let refreshButtonPaddingVertical: CGFloat = 32
    private let shadowRadius: CGFloat = 12
    private let userButtonCornerRadius: CGFloat = 24
    private let userButtonPaddingHorizontal: CGFloat = 20
    private let userButtonPaddingVertical: CGFloat = 10
    private let userMarqueeBackgroundAnimationDuration: CGFloat = 2.0
    private let userMarqueeBackgroundFinalY: CGFloat = -20
    private let userMarqueeCornerRadius: CGFloat = 12
    private let userMarqueeFrameHeight: CGFloat = 200
    private let userMarqueeFrameWidth: CGFloat = UIScreen.main.bounds.width - 22
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if self.isDisplayingUserMarquee && !self.userViewModel.isSignedIn {
                        ZStack {
                            Image("signinbg")
                                .resizable()
                                .scaledToFill()
                                .offset(y: self.userMarqueeBackgroundY)
                                .frame(
                                    width: self.userMarqueeFrameWidth,
                                    height: self.userMarqueeFrameHeight
                                )
                                .clipped()
                                .cornerRadius(self.userMarqueeCornerRadius)
                            
                            Text("Sign In")
                                .padding(.vertical, self.userButtonPaddingVertical)
                                .padding(.horizontal, self.userButtonPaddingHorizontal)
                                .background(Color.white)
                                .cornerRadius(self.userButtonCornerRadius)
                        }
                        .onTapGesture {
                            withAnimation {
                                self.displayViewModel.isDisplayingSignIn = true
                            }
                        }
                        .padding(.horizontal, self.albumSpacing)
                        .padding(.bottom, self.userMarqueePaddingBottom)
                        .transition(.offset(y: -self.userMarqueeFrameHeight - self.paddingTop))
                    }
                    
                    HStack {
                        if self.isDisplayingNewestReleases {
                            Button(action: {
                                withAnimation {
                                    self.isDisplayingUserMarquee.toggle()
                                    self.isDisplayingNewestReleases.toggle()
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.leading, self.newestReleasesBackButtonPaddingLeading)
                                    .padding(.trailing, self.newestReleasesBackButtonPaddingTrailing)
                            }
                        }
                        
                        Text("Newest releases")
                            .font(self.isDisplayingNewestReleases ? .title : .title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.leading, self.albumSpacing)
                    .padding(.bottom, self.albumSpacing)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(self.viewModel.albums, id: \.id) { album in
                                HomeAlbumView(
                                    contextAlbum: self.$contextAlbum,
                                    contextPosition: self.$contextPosition,
                                    isDisplayingContext: self.$isDisplayingContext,
                                    album: album
                                )
                                .frame(width: self.albumSize, height: self.albumSize)
                                .highPriorityGesture(
                                    TapGesture().onEnded { _ in
                                        self.album = album
                                        self.albumToggle.toggle()
                                        
                                        withAnimation {
                                            self.isDisplayingAlbum = true
                                        }
                                    }
                                )
                                .padding(.leading, self.albumSpacing)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    self.isDisplayingUserMarquee = false
                                    self.isDisplayingNewestReleases = true
                                }
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Colors.lightGray)
                                        .frame(width: self.albumSize, height: self.albumSize)
                                        .padding(.horizontal, self.albumSpacing)
                                    
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                }
                .padding(.top, self.paddingTop)
            }
            .zIndex(0)
            
            if self.auxiliaryContextDisplay {
                ZStack {
                    VStack {
                        if self.isDisplayingGradient {
                            LinearGradient(
                                gradient: self.viewModel.gradient,
                                startPoint: .top,
                                endPoint: .center
                            )
                            .opacity(self.gradientOpacity)
                            .transition(.opacity)
                        }
                    }
                    .task {
                        if let gradient = await self.viewModel.fetchGradient(self.contextAlbum!) {
                            await MainActor.run {
                                self.viewModel.gradient = gradient
                                withAnimation(.easeOut(duration: self.gradientAnimationDuration)) {
                                    self.isDisplayingGradient = true
                                }
                            }
                        }
                    }
                    
                    CommonBackgroundBlur()
                        .scaleEffect(self.auxiliaryContextDisplay ? self.backgroundBlurScaling : 1)
                }
                .onTapGesture {
                    self.auxiliaryContextRemoval = false
                    
                    withAnimation(.easeOut(duration: self.contextExitAnimationDuration)) {
                        self.auxiliaryContextDisplay = false
                        self.isDisplayingGradient = false
                        self.displayViewModel.isDisplayingNavigation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.contextExitAnimationDuration) {
                        self.isDisplayingContext = false
                        self.album = nil
                        self.contextAlbum = nil
                    }
                }
                .zIndex(1)
            }
            
            if self.isDisplayingContext {
                ZStack {
                    if self.auxiliaryContextRemoval {
                        VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text(self.contextAlbum!.type.uppercased())
                                    
                                    Spacer()
                                    
                                    Text(self.contextAlbum!.release_date)
                                }
                                .font(.system(size: self.contextDetailsFontSize * self.contextMenuScalingFactor))
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .padding(.bottom, self.contextDetailsPaddingBottom)
                                
                                Text(self.contextAlbum!.name)
                                    .font(.system(size: self.contextNameFontSize * self.contextMenuScalingFactor))
                                    .fontWeight(.semibold)
                                
                                Text(self.contextAlbum!.artists.joined(separator: ", "))
                                    .font(.system(size: self.contextArtistsFontSize * self.contextMenuScalingFactor))
                                    .padding(.bottom, self.contextCoverPaddingBottom)
                            }
                            .frame(width: self.albumSize * self.contextMenuScalingFactor)
                            .opacity(0)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Color.clear
                                    .frame(height: self.albumSize * self.contextMenuScalingFactor)
                                    .padding(.bottom, self.contextCoverPaddingBottom)
                                
                                HStack {
                                    Text(self.contextAlbum!.type.uppercased())
                                    
                                    Spacer()
                                    
                                    Text(self.contextAlbum!.release_date)
                                }
                                .font(.system(size: self.contextDetailsFontSize * self.contextMenuScalingFactor))
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .padding(.bottom, self.contextDetailsPaddingBottom)
                                
                                Text(self.contextAlbum!.name)
                                    .font(.system(size: self.contextNameFontSize * self.contextMenuScalingFactor))
                                    .fontWeight(.semibold)
                                
                                Text(self.contextAlbum!.artists.joined(separator: ", "))
                                    .font(.system(size: self.contextArtistsFontSize * self.contextMenuScalingFactor))
                                    .foregroundColor(.gray)
                            }
                            .frame(width: self.albumSize * self.contextMenuScalingFactor)
                            .padding(self.albumSpacing)
                            .background(Color.white)
                            .cornerRadius(self.contextCornerRadius)
                        }
                    }
                    
                    KFImage(URL(string: self.contextAlbum!.image_url_hq!))
                        .resizable()
                        .frame(
                            width: self.albumSize * (self.auxiliaryContextDisplay ? self.contextMenuScalingFactor : 1),
                            height: self.albumSize * (self.auxiliaryContextDisplay ? self.contextMenuScalingFactor : 1)
                        )
                }
                .position(x: self.contextMenuMidPointPosition.x, y: self.contextMenuMidPointPosition.y)
                .onAppear {
                    withAnimation(.easeOut) {
                        self.auxiliaryContextRemoval = true
                    }
                    withAnimation {
                        self.auxiliaryContextDisplay = true
                    }
                }
                .zIndex(2)
            }
            
            if self.isDisplayingAlbum {
                if self.albumToggle {
                    ZStack {
                        Color.white
                        
                        AlbumView(
                            album: self.album!,
                            displayBinding: self.$isDisplayingAlbum,
                            rating: self.userViewModel.albumRatings[self.album!.id] ?? 0
                        )
                    }
                    .transition(.move(edge: .trailing))
                    .zIndex(3)
                } else {
                    ZStack {
                        Color.white
                        
                        AlbumView(
                            album: self.album!,
                            displayBinding: self.$isDisplayingAlbum,
                            rating: self.userViewModel.albumRatings[self.album!.id] ?? 0
                        )
                    }
                    .transition(.move(edge: .trailing))
                    .zIndex(3)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: self.userMarqueeBackgroundAnimationDuration)) {
                self.userMarqueeBackgroundY = self.userMarqueeBackgroundFinalY
            }
            Task {
                await self.viewModel.fetchNewReleases()
            }
        }
    }
    
    private var contextMenuMidPointPosition: CGPoint {
        if self.auxiliaryContextDisplay {
            return CGPoint(
                x: self.contextFinalPosition.x,
                y: self.contextFinalPosition.y
            )
        } else {
            return CGPoint(
                x: self.contextPosition.x + (self.albumSize / 2),
                y: self.contextPosition.y + (self.albumSize / 2)
            )
        }
    }
    private var contextMenuScalingFactor: CGFloat {
        if self.isDisplayingContext {
            return contextScalingFactor
        } else {
            return 1
        }
    }
    private var userMarqueePaddingBottom: CGFloat {
        if self.isDisplayingNewestReleases {
            return 80
        } else {
            return 40
        }
    }
}

struct HomeAlbumView: View {
    @Environment(CommonDisplayViewModel.self) private var displayViewModel
    
    @State private var changeNotifier: Bool = false
    
    @Binding var contextAlbum: AlbumModel?
    @Binding var contextPosition: CGPoint
    @Binding var isDisplayingContext: Bool
    
    let album: AlbumModel
    
    private let animationDuration: CGFloat = 0.2
    private let pressDuration: CGFloat = 0.5
    
    var body: some View {
        Button(action: { }) {
            KFImage(URL(string: self.album.image_url_hq!))
                .resizable()
                .opacity(self.contextAlbum == self.album ? 0 : 1)
        }
        .disabled(self.isDisplayingContext)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: self.pressDuration)
                .onEnded { _ in
                    self.contextAlbum = self.album
                    self.changeNotifier.toggle()
                    
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        self.displayViewModel.isDisplayingNavigation = false
                        self.isDisplayingContext = true
                    }
                }
        )
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: self.changeNotifier) {
                        if self.contextAlbum == self.album {
                            let frame = geometry.frame(in: .global)
                            self.contextPosition = CGPoint(x: frame.minX, y: frame.minY)
                        }
                    }
            }
        )
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        @State var displayViewModel = CommonDisplayViewModel()
        @State var userViewModel = CommonUserViewModel(context: PersistenceController.shared.container.viewContext)
                      
        TabsView()
            .environment(displayViewModel)
            .environment(userViewModel)
            .ignoresSafeArea(.all)
    }
}
