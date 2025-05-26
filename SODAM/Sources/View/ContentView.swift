import SwiftUI
import Combine

public struct ContentView: View {
    @StateObject var contentViewModel: ContentViewModel = ContentViewModel()
    @StateObject var playerViewModel = PlayerViewModel.shared
    @State private var offset = CGSizeMake(0, 300)
    public init() {
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                TabBarComponent()
                if(contentViewModel.playerState) {
                    PlayerView()
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if PlayerViewModel.shared.isLongVer {
                                        offset.height = gesture.translation.height
                                    } else {
                                        offset = gesture.translation
                                    }
                                }
                                .onEnded { gesture in
                                        if gesture.translation.height <= -(geo.size.height / 2) + (geo.size.height / 6) {
                                            offset.height = -(geo.size.height / 2) + (geo.size.height / 6)
                                        } else if gesture.translation.height >= geo.size.height / 2.6 {
                                            offset.height = geo.size.height / 2.6
                                        }
                                    if !PlayerViewModel.shared.isLongVer {
                                        if gesture.translation.width <= 0 {
                                            offset.width = 0
                                        } else if gesture.translation.width >= (geo.size.width * 0.9) {
                                            offset.width = (geo.size.width * 0.9) - 15
                                        }
                                    }
                                }
                        )
                }
            }
            .onAppear(perform: {
                offset = CGSizeMake(0, (geo.size.height / 2.6))
                }
            )
            .onChange(of: playerViewModel.isLongVer, {
                offset = CGSizeMake(0, offset.height)
            })
        }
    }
}

#Preview {
    ContentView()
}

