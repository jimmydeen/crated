import SwiftUI

struct Title: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

struct Subtitle: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .lineLimit(1)
    }
}
