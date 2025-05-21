import Foundation
import Combine

class ContentViewModel: ObservableObject {
//    let shared = ContentViewModel()
//    let playerPublisher: AnyPublisher<DetailModel, Never>
    @Published var playerState: Bool = false
    private var cancellables: Set<AnyCancellable>
//    @Published var playModel: DetailModel?
//    @Published var playerViewModel: PlayerViewModel
//    PlayerViewModel(title: playerTitle, imageUrl: playerImageURL, audioUrl: playerAudioURL)

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
          }
        }
        .store(in: &cancellables)
        
    }
      
}

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
