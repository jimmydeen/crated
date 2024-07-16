import Foundation
import SwiftUI

extension Color {
    func toRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return (red, green, blue)
    }
}
