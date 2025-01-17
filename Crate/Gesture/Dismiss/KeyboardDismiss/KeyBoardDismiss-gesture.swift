import SwiftUI

// A reusable ViewModifier for dismissing the keyboard with gestures
struct DismissKeyboardModifier: ViewModifier {
    let dismissOnTap: Bool
    let dismissOnSwipe: Bool
    @FocusState.Binding var isFocused: Bool

    func body(content: Content) -> some View {
        if (isFocused) {
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
        } else {
            content
        }
    }
}

// Extension to make the modifier easier to apply
extension View {
    func dismissKeyboard(tap: Bool = true, swipe: Bool = true) {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
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
