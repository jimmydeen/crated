import SwiftUI

struct RoundedTextField: View {
    @Binding var text: String
    
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .padding(.horizontal, .standard)
            .padding(.vertical, .tiny)
            .background(Color.lightGray)
            .cornerRadius(.small)
    }
}

struct RoundedTextEditor: View {
    @Binding var text: String
    
    let placeholder: String
    
    var body: some View {
        TextEditor(text: $text)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .padding(.horizontal, .standard)
            .padding(.vertical, .tiny)
            .background(Color.lightGray)
            .cornerRadius(.small)
    }
}

struct RoundedSecureField: View {
    @Binding var text: String
    
    let placeholder: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding(.horizontal, .standard)
            .padding(.vertical, .tiny)
            .background(Color.lightGray)
            .borderRadius(.standard)
            .cornerRadius(.small)
    }
}
