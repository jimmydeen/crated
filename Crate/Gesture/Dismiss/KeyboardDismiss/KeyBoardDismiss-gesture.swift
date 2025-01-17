import SwiftUI

// A reusable ViewModifier for dismissing the keyboard with gestures
struct DismissKeyboardModifier: ViewModifier {
    let dismissOnTap: Bool
    let dismissOnSwipe: Bool

    func body(content: Content) -> some View {
        content
            .highPriorityGesture(
                DragGesture().onChanged { _ in
                    if dismissOnSwipe {
                        resignKeyboard()
                    }
                }
            )
            .onTapGesture {
                if dismissOnTap {
                    resignKeyboard()
                }
            }
    }
}

// Extension to make the modifier easier to apply
extension View {
    func dismissKeyboardOnInteraction(tap: Bool = true, swipe: Bool = true) -> some View {
        self.modifier(DismissKeyboardModifier(dismissOnTap: tap, dismissOnSwipe: swipe))
    }
}


func resignKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}
