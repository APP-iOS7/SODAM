import Foundation
import SwiftUICore
import AVFoundation
import MediaPlayer

class PlayerViewModel: ObservableObject {
    static let shared = PlayerViewModel()
    
    @Published private(set) var duration: TimeInterval = 0.0
    @Published private(set) var currentTime: TimeInterval = 0.0
    @Published var isPlaying: Bool = false
    @Published var isLongVer: Bool = true
    @Published var audioData: Data?
    @Published var playerItem: AVPlayerItem?
    @Published var playModel: DetailModel? {
        didSet {
            if playModel != nil {
                setPlayer()
                play()
                addPeriodicTimeObserver()
            } else {
                // playModel이 nil이 되면 플레이어 상태 초기화
                self.isPlaying = false
                self.currentTime = 0.0
                self.duration = 0.0
                // MPNowPlayingInfoCenter 정보 초기화
                self.session?.nowPlayingInfoCenter.nowPlayingInfo = nil
                // 오디오 세션 비활성화
                
            }
        }
        willSet {
            if playModel != nil {
                    removePeriodicTimeObserver()
                    if let player = audioPlayer {
                        self.session?.removePlayer(player)
                    }
                    // 플레이어를 닫을 때 원격 명령 센터에서 타겟을 제거합니다.
                    self.session?.remoteCommandCenter.pauseCommand.removeTarget(nil)
                    self.session?.remoteCommandCenter.playCommand.removeTarget(nil)
                    self.session?.remoteCommandCenter.skipBackwardCommand.removeTarget(nil)
                    self.session?.remoteCommandCenter.skipForwardCommand.removeTarget(nil)
                    self.session = nil // 세션을 nil로 설정하여 리소스 해제
            }
        }
    }
    
    private var audioPlayer: AVPlayer?
    private var timeObserver: Any?
    private var session: MPNowPlayingSession?
    
    private func setNowPlaying() {
        
        // Example of responding to play and pause commands
        guard let player = audioPlayer,
                  let playModel = playModel,
                  let playerItem = playerItem else { return }
            self.session = MPNowPlayingSession(players: [player])
            self.session?.automaticallyPublishesNowPlayingInfo = true
            
            
        let title = playModel.title
            var nowPlayingInfo: [String: Any] = [
                MPMediaItemPropertyTitle: title,
                MPMediaItemPropertyPlaybackDuration: playerItem.duration.seconds,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime().seconds,
                MPNowPlayingInfoPropertyPlaybackRate: player.rate,
            ]
            
            //            if let imageUrl = URL(string: playModel.imageUrl ?? "") {
            //                if let data = try? Data(contentsOf: imageUrl), let item = UIImage(data: data) {
            //                    let artwork = MPMediaItemArtwork(boundsSize: item.size, requestHandler: {_ in item})
            //                    playerItem.nowPlayingInfo = [
            //                        MPMediaItemPropertyArtwork: artwork
            //                    ]
            //                } else {
            if let item = UIImage(named: "defaultImage") {
                let artwork = MPMediaItemArtwork(boundsSize: item.size) { _ in return item }
                nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            }
            
            playerItem.nowPlayingInfo = nowPlayingInfo
            setupRemoteCommandCenter()
    }
    // Remote Command Center 설정
    private func setupRemoteCommandCenter() {
        guard let remoteCommandCenter = self.session?.remoteCommandCenter else { return }
        remoteCommandCenter.playCommand.removeTarget(nil)
        remoteCommandCenter.pauseCommand.removeTarget(nil)
        remoteCommandCenter.skipBackwardCommand.removeTarget(nil)
        remoteCommandCenter.skipForwardCommand.removeTarget(nil)
        
        remoteCommandCenter.playCommand.addTarget { [weak self] event in
            self?.play()
            return .success
        }
        
        remoteCommandCenter.pauseCommand.addTarget { [weak self] event in
            self?.pause()
            return .success
        }
        
        remoteCommandCenter.skipBackwardCommand.preferredIntervals = [15.0]
        remoteCommandCenter.skipBackwardCommand.addTarget { [weak self] event in
            guard let self = self, let player = self.audioPlayer else { return .commandFailed }
            let skipCommand = event as! MPSkipIntervalCommandEvent
            let newTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(-skipCommand.interval, preferredTimescale: 1))
            player.seek(to: newTime)
            playerItem?.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = newTime.seconds
            return .success
        }
        remoteCommandCenter.skipForwardCommand.preferredIntervals = [15.0]
        remoteCommandCenter.skipForwardCommand.addTarget { [weak self] event in
            guard let self = self, let player = self.audioPlayer else { return .commandFailed }
            let skipCommand = event as! MPSkipIntervalCommandEvent
            let newTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(skipCommand.interval, preferredTimescale: 1))
            player.seek(to: newTime)
            playerItem?.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = newTime.seconds
            return .success
        }
    }
    /**플레이어 세팅*/
    private func setPlayer() {
        do {
            // 무음모드에서도 재생되도록 설정
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화. 앱이 백그라운드로 이동하거나 중단되었을 때, 다시 활성화해야함
            guard let url = URL.init(string: playModel?.audioUrl ?? "") else { return }
            playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer.init(playerItem: playerItem)
            setNowPlaying()
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
        if currentTime >= duration && duration > 0 {
            audioPlayer?.seek(to: .zero)
        }
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
        self.isPlaying = true
        playerItem?.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime().seconds
        playerItem?.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
        print(audioPlayer.currentTime().seconds)
        print(audioPlayer.rate)
    }
    
    /**오디오 정지*/
    func pause() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
        self.isPlaying = false
        playerItem?.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime().seconds
        playerItem?.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
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
        do {
            pause()
            removePeriodicTimeObserver()
            sendPlayState(state: false)
            if let player = audioPlayer {
                self.session?.removePlayer(player)
            }
            self.session?.automaticallyPublishesNowPlayingInfo = false
            // 플레이어를 닫을 때 원격 명령 센터에서 타겟을 제거
            self.session?.remoteCommandCenter.pauseCommand.removeTarget(nil)
            self.session?.remoteCommandCenter.playCommand.removeTarget(nil)
            self.session?.remoteCommandCenter.skipBackwardCommand.removeTarget(nil)
            self.session?.remoteCommandCenter.skipForwardCommand.removeTarget(nil)
            self.session = nil // 세션을 nil로 설정하여 리소스 해제
            // 다른 앱에 오디오 세션 활성화가 해제되었음을 알립니다.
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("close audio error: \(error)")
        }
    }
}
