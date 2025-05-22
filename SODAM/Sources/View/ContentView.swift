import SwiftUI
import Combine

public struct ContentView: View {
    @StateObject var contentViewModel: ContentViewModel = ContentViewModel()
    public init() {
    }
    
    public var body: some View {
        ZStack {
            TabBarComponent()
            if(contentViewModel.playerState) {
                VStack {
                    Spacer()
                    PlayerView()
                            .padding(.bottom, 50)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

