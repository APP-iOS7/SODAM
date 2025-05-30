import Foundation
import AVFoundation

class PlayerViewModel: ObservableObject {
    static let shared = PlayerViewModel()
    
    @Published private(set) var duration: TimeInterval = 0.0
    @Published private(set) var currentTime: TimeInterval = 0.0
    @Published var isPlaying: Bool = false
    @Published var isLongVer: Bool = true
    @Published var audioData: Data?
    @Published var playModel: DetailModel? {
        didSet {
            if playModel != nil {
                setPlayer()
                play()
                addPeriodicTimeObserver()
            }
                }
    }
    
    private var audioPlayer: AVPlayer?
    private var timeObserver: Any?

    /**플레이어 세팅*/
    private func setPlayer() {
        do {
            // 무음모드에서도 재생되도록 설정
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화. 앱이 백그라운드로 이동하거나 중단되었을 때, 다시 활성화해야함
            guard let url = URL.init(string: playModel?.audioUrl ?? "") else { return }
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer.init(playerItem: playerItem)
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    /// Adds an observer of the player timing.
    private func addPeriodicTimeObserver() {
        // Create a 0.5 second interval time.
        let interval = CMTime(value: 1, timescale: 2)
        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval,
                                                      queue: .main) { [weak self] time in
            guard let self else { return }
            // Update the published currentTime and duration values.
            currentTime = time.seconds
            duration = audioPlayer?.currentItem?.duration.seconds ?? 0.0
        }
    }


    /// Removes the time observer from the player.
    private func removePeriodicTimeObserver() {
        guard let timeObserver else { return }
        audioPlayer?.removeTimeObserver(timeObserver)
        self.timeObserver = nil
    }
    /**오디오 재생*/
    func play() {
        audioPlayer?.play()
        self.isPlaying = true
       }
    
    /**오디오 정지*/
    func pause() {
        audioPlayer?.pause()
        self.isPlaying = false
        removePeriodicTimeObserver()
    }
    
    /**이미지URL호출
     * - Returns: 이미지 URL
     */
    func getImageURL() -> URL? {
        //모델 변경 시 if let이나 guard let 사용
        return URL(string: playModel?.imageUrl ?? "")
    }
    
    func getTitle() -> String {
        return playModel?.title ?? ""
    }
    
    final func close() {
        pause()
        sendPlayState(state: false)
    }
}
