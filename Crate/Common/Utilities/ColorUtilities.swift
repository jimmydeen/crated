import Foundation
import SwiftUI

class ColorUtilities {
    static func luminance(of color: Color) -> CGFloat {
        guard let rgb = color.toRGB() else {
            return 0
        }
        return 0.299 * rgb.red + 0.587 * rgb.green + 0.114 * rgb.blue
    }
}
