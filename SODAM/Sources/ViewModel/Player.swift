import Foundation
import AVFoundation

class Player: ObservableObject {
    static let shared = Player()
    
    @Published var isPlaying: Bool = false 
    @Published var audioData: Data?
    @Published var playModel: DetailModel? {
        didSet {
            if playModel != nil {
                setPlayer()
                play()
            }
        }
    }
    
    var audioPlayer: AVPlayer?
    
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
    
    /**오디오 재생*/
    final func play() {
        audioPlayer?.play()
        self.isPlaying = true
    }
    
    /**오디오 정지*/
    final func pause() {
        audioPlayer?.pause()
        self.isPlaying = false
    }
    
    /**이미지URL호출
     * - Returns: 이미지 URL
     */
    final func getImageURL() -> URL? {
        //모델 변경 시 if let이나 guard let 사용
        return URL(string: playModel?.imageUrl ?? "")
    }
    
    final func getTitle() -> String {
        return playModel?.title ?? ""
    }
}

