import Foundation
import Combine

///오디오 플레이어로 관광지 정보 전달 및 오디오 플레이어뷰 on/off 관리
let notificationSubject = PassthroughSubject<(DetailModel?, Bool), Never>()

class ContentViewModel: ObservableObject {
    @Published var playerState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        notificationSubject
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main) // 중복 호출 방지
            .sink {[weak self] (model, state) in
                //sendPlayState함수로부터 오디오 재생을 위한 관광지 정보를 받아옴
                //playerState로 플레이어뷰 on/off 조절
                self?.playerState = state
                //받아온 관광지 정보를 오디오 재생을 위해 플레이어뷰모델로 전달
                PlayerViewModel.shared.playModel = model
            }.store(in: &cancellables)
    }
}

/**
 * 오디오 플레이어 켜기 및 오디오 재생 이벤트
 *  - Parameters:
 *     - state: 플레이어 UI상태(기본값: true)
 *     - spot: 오디오 재생할 장소 데이터
 */
func sendPlayState(state: Bool = true, spot: DetailModel) {
    notificationSubject.send((spot, state))
}

/**
 * 오디오 플레이어 상태 변경
 *  - Parameters:
 *     - state: 플레이어 UI상태(기본값: false)
 */
func sendPlayState(state: Bool = false) {
    notificationSubject.send((nil, state))
}
