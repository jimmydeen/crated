import SwiftUI

struct RoundedButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            HStack {
                Spacer()
                
                Text(text)
                
                Spacer()
            }
            .padding(.small)
            .background(Color.lightGray)
            .borderRadius(.standard)
            .cornerRadius(.small)
            .foregroundColor(.blue)
        }
    }
}

struct RoundedSecondaryButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            HStack {
                Spacer()
                
                Text(text)
                
                Spacer()
            }
            .padding(.small)
            .background(Color.lightGray)
            .borderRadius(.standard)
            .cornerRadius(.small)
            .foregroundColor(.blue)
        }
    }
}

struct RoundedNavButton<Destination: View>: View {
    let text: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Spacer()
                
                Text(text)
                
                Spacer()
            }
            .padding(.small)
            .background(Color.lightGray)
            .borderRadius(.standard)
            .cornerRadius(.small)
            .foregroundColor(.blue)
        }
    }
}
