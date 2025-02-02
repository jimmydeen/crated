import SwiftUI
import Kingfisher

enum BorderRadius: CGFloat {
    case small = 0.5
    case standard = 1
    case large = 2
    case huge = 4
}

enum BoxShadow: CGFloat {
    case small = 6
    case standard = 8
    case large = 12
    case huge = 16
}

enum BoxSize: CGFloat {
    case small = 32
    case standard = 64
    case large = 108
    case huge = 216
}

enum CornerRadius: CGFloat {
    case small = 8
    case standard = 12
    case large = 16
    case huge = 24
}

enum Padding: CGFloat {
    case tiny = 6
    case small = 8
    case standard = 12
    case large = 16
    case huge = 24
    case extraHuge = 48
}

enum Spacing: CGFloat {
    case small = 8
    case standard = 12
    case large = 16
}

extension View {
    func borderRadius(_ size: BorderRadius) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: size.rawValue))
    }
    
    func boxShadow(_ size: BoxShadow) -> some View {
        self.shadow(radius: size.rawValue)
    }
    
    func cornerRadius(_ size: CornerRadius) -> some View {
        self.cornerRadius(size.rawValue)
    }
    
    func padding(_ edges: Edge.Set = .all, _ size: Padding) -> some View {
        self.padding(edges, size.rawValue)
    }
    
    func padding(_ size: Padding) -> some View {
        self.padding(size.rawValue)
    }
}

extension KFImage {
    func boxSize(_ size: BoxSize) -> some View {
        self
            .resizable()
            .frame(width: size.rawValue, height: size.rawValue)
    }
}

extension PlaceholderProfilePictureView {
    func boxSize(_ size: BoxSize) -> some View {
        self
            .frame(width: size.rawValue, height: size.rawValue)
    }
}
