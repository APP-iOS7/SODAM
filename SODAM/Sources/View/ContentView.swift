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
              DragGesture() // 플레이어 뷰 드래그에 따른 이동 조작
                .onChanged { gesture in
                  if playerViewModel.isLongVer { //롱버전일때 상하 위치만 조절
                    offset.height = accumulatedOffset.height + gesture.translation.height
                  } else { // 숏버전: 상하좌우 조작 가능
                    offset = accumulatedOffset + gesture.translation
                  }
                }
                .onEnded { gesture in //이동 후 플레이어가 화면 밖으로 나간 경우 제어
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
      .onAppear(perform: { //플레이어 첫 위치
        offset = CGSizeMake(0, (geo.size.height / 2.6))
        accumulatedOffset = CGSizeMake(0, (geo.size.height / 2.6))
      })
      .onChange(of: playerViewModel.isLongVer, { //롱버전될 때 위치 조절
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
