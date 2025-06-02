import SwiftUI
import Combine

public struct ContentView: View {
  @StateObject var contentViewModel: ContentViewModel = ContentViewModel()
  @StateObject var playerViewModel = PlayerViewModel.shared
  @State private var offset = CGSize.zero
  @State private var accumulatedOffset = CGSize.zero
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
                  if playerViewModel.isLongVer {
                    offset.height = accumulatedOffset.height + gesture.translation.height
                  } else {
                    offset = accumulatedOffset + gesture.translation
                  }
                }
                .onEnded { gesture in
                  if offset.height <= -(geo.size.height / 2) + (geo.size.height / 11) {
                    offset.height = -(geo.size.height / 2) + (geo.size.height / 11)
                    accumulatedOffset.height = -(geo.size.height / 2) + (geo.size.height / 11)
                  } else if offset.height >= geo.size.height / 2.6 {
                    offset.height = geo.size.height / 2.6
                    accumulatedOffset.height = geo.size.height / 2.6
                  } else {
                    accumulatedOffset.height = accumulatedOffset.height + gesture.translation.height
                  }
                  if !playerViewModel.isLongVer {
                    if offset.width <= 0 {
                      offset.width = 0
                      accumulatedOffset.width = 0
                    } else if offset.width >= (geo.size.width - 70) {
                      offset.width = (geo.size.width - 70)
                      accumulatedOffset.width = (geo.size.width - 70)
                    } else {
                      accumulatedOffset.width = accumulatedOffset.width + gesture.translation.width
                    }
                  } else {
                    accumulatedOffset.width = 0
                  }
                }
            )
        }
      }
      .onAppear(perform: {
        offset = CGSizeMake(0, (geo.size.height / 2.6))
        accumulatedOffset = CGSizeMake(0, (geo.size.height / 2.6))
      })
      .onChange(of: playerViewModel.isLongVer, {
        if playerViewModel.isLongVer {
          offset.width = 0
          accumulatedOffset.width = 0
        }
      })
    }
  }
}

#Preview {
  ContentView()
}

extension CGSize {
  static func + (lhs: Self, rhs: Self) -> Self {
    CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
}
