import Foundation
import Combine

let notificationSubject = PassthroughSubject<(DetailModel?, Bool), Never>()

class ContentViewModel: ObservableObject {
    @Published var playerState: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        notificationSubject.sink {[weak self] (model, state) in
            PlayerViewModel.shared.playModel = model
            self?.playerState = state
        }.store(in: &cancellables)
    }
}

/** 오디오 재생
 * - Parameters:
 *      - state: 플레이어 UI상태
 *      - spot: 오디오 재생할 장소 데이터
 */
func sendPlayState(state: Bool, spot: DetailModel) {
    notificationSubject.send((spot, state))
    print("0")
}

/** 오디오 플레이어 상태 변경
 * - Parameters:
 *      - state: 플레이어 UI상태
 */
func sendPlayState(state: Bool) {
    notificationSubject.send((nil, state))
}
