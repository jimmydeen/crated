import Foundation
import SwiftUI

struct CommonDarkeningBlur: View {
    var body: some View {
        Color.black.opacity(0.4)
            .transition(.opacity)
    }
}
