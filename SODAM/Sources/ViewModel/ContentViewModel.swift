import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var playerState: Bool = false
    private var cancellables: Set<AnyCancellable>

    init(cancellables: Set<AnyCancellable> = []) {
      self.cancellables = cancellables
      bindingNotification()
    }
    
    private func bindingNotification() {
        NotificationCenter.default.publisher(for: .playerNotification)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] notification in
          guard let self = self else { return }
          if let userInfo = notification.userInfo,
             let state = userInfo["playerState"] as? Bool {
              playerState = state
              if let model = userInfo["playeModel"] as? DetailModel {
                  PlayerViewModel.shared.playModel = model
              }
          }
        }
        .store(in: &cancellables)
        
    }
}

/** 오디오 재생
 * - Parameters:
 *      - state: 플레이어 UI상태
 *      - spot: 오디오 재생할 장소 데이터
 */
func sendPlayState(state: Bool, spot: DetailModel) {
  NotificationCenter.default.post(
    name: .playerNotification,
    object: nil,
    userInfo: ["playerState": state, "playeModel": spot]
  )
}

/** 오디오 플레이어 상태 변경
 * - Parameters:
 *      - state: 플레이어 UI상태
 */
func sendPlayState(state: Bool) {
  NotificationCenter.default.post(
    name: .playerNotification,
    object: nil,
    userInfo: ["playerState": state]
  )
}

extension Notification.Name {
  static let playerNotification = Notification.Name("playerNotification")
}
