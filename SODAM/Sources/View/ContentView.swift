import SwiftUI

public struct ContentView: View {
  @StateObject private var userLocation = UserLocation.shared
  
  /*
   MARK: 플레이어뷰모델에 데이터 전달방식 고민
   1. SwiftData에 데이터 등록하고 ContentView에서 받아오기
   2. 필요한 정보만 (제목, 이미지url, 오디오url) userDefalt에 저장 **일단 이 방식입니다.
   3. combine
   */
  @AppStorage("playerState") var playerState: Bool = UserDefaults.standard.bool(forKey: "playerState")
  @AppStorage("playerTitle") var playerTitle: String = (UserDefaults.standard.string(forKey: "playerTitle") ?? "")
  @AppStorage("playerImageURL") var playerImageURL: String = (UserDefaults.standard.string(forKey: "playerImageURL") ?? "")
  @AppStorage("playerAudioURL") var playerAudioURL: String = (UserDefaults.standard.string(forKey: "playerAudioURL") ?? "")
  public init() {
  }
  
  public var body: some View {
    ZStack {
      TabBarComponent()
      
      // 250521 1402 KTG
      // 임시 주석.
//      //MARK: 테스트 위한 오디오 재생 버튼-추후 삭제
//      Button {
//        //TODO: 만약 재생하고 있는 오디오가 다시 입력될 오디오랑 같을 경우에 다시 처음부터 재생
//        playerTitle = "창덕궁"
//        playerImageURL = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
//        playerAudioURL = "https://sfj608538-sfj608538.ktcdn.co.kr/file/audio/56/998.mp3"
//        playerState = true
//      } label: {
//        Text("재생")
//      }
      if(playerState) {
        VStack {
          Spacer()
          PlayerView(playerViewModel: PlayerViewModel(title: playerTitle, imageUrl: playerImageURL, audioUrl: playerAudioURL))
            .padding(.bottom, 50)
        }
      }
    }
  }
}

#Preview {
  ContentView()
}

