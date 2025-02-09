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
            .font(.custom("DM Mono", size: 18))
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
            .font(.custom("DM Mono", size: 18))
    }
}

struct RoundedSecureField: View {
    @Binding var text: String
    
    let placeholder: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .padding(.horizontal, .standard)
            .padding(.vertical, .tiny)
            .background(Color.lightGray)
            .borderRadius(.standard)
            .cornerRadius(.small)
            .font(.custom("DM Mono", size: 18))
    }
}

struct RoundedTogglableSecureField: View {
    @Binding var text: String
    
    @State var isHidden: Bool = true
    
    let placeholder: String
    
    var body: some View {
        HStack {
            if isHidden {
                SecureField(placeholder, text: $text)
                    .frame(height: 20)
                    .font(.custom("DM Mono", size: 18))
            } else {
                TextField(placeholder, text: $text)
                    .frame(height: 20)
                    .font(.custom("DM Mono", size: 18))
            }
            
            Spacer()
            
            if !text.isEmpty {
                Text(isHidden ? "Show" : "Hide")
                    .foregroundColor(isHidden ? .black : .red)
                    .onTapGesture {
                        isHidden.toggle()
                    }
                    .font(.custom("DM Mono", size: 15))
            }
        }
        .autocapitalization(.none)
        .autocorrectionDisabled()
        .padding(.horizontal, .standard)
        .padding(.vertical, .tiny)
        .background(Color.lightGray)
        .borderRadius(.standard)
        .cornerRadius(.small)
    }
}
