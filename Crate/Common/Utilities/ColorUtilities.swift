import Foundation
import SwiftUI

class ColorUtilities {
    static func luminance(of color: Color) -> CGFloat {
        guard let rgb = color.toRGB() else {
            return 0
        }
        
        // Calculate brightness using the luminance formula
        return 0.299 * rgb.red + 0.587 * rgb.green + 0.114 * rgb.blue
    }

    static func sortColorsByBrightness(_ colors: [Color]) -> [Color] {
        return colors.sorted { luminance(of: $0) < luminance(of: $1) }
    }
}
