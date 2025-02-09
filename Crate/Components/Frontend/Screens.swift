import SwiftUI

struct BackgroundBlurView: View {
    var body: some View {
        Color.white.opacity(0.4)
            .background(.ultraThinMaterial)
    }
}

struct EmptyMessageView: View {
    let text: String
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Text(text)
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct PlaceholderProfilePictureView: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Spacer()
        }
        .background(Color.lightGray)
    }
}

struct SignInPrompt: View {
    let text: String
    
    var body: some View {
        VStack {
            Spacer()
            
            NavigationLink(destination: AccountView(viewModel: AccountViewModel())) {
                Text(text)
                    .foregroundColor(.black)
                    .padding(.small)
                    .background(Color.lightGray)
                    .cornerRadius(.standard)
            }
            
            Spacer()
        }
    }
}
