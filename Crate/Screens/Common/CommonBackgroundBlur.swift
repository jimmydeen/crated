import Foundation
import SwiftUI

struct CommonBackgroundBlur: View {
    var body: some View {
        Color.white.opacity(0.4)
            .background(.ultraThinMaterial)
            .transition(.opacity)
    }
}
