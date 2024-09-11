import SwiftUI

extension View {
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            return AnyView(apply(self))
        } else {
            return AnyView(self)
        }
    }
}
