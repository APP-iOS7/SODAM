import Foundation
import SwiftUICore
import AVFoundation
import MediaPlayer

class PlayerViewModel: ObservableObject {
    static let shared = PlayerViewModel()
    
    let audioPlayer = AudioPlayer()
    
    @Published private(set) var duration: TimeInterval = 0.0
    @Published private(set) var currentTime: TimeInterval = 0.0
    @Published var isPlaying: Bool = false
    @Published var isLongVer: Bool = true
    @Published var audioData: Data?
    @Published var playerItem: AVPlayerItem?
    @Published var playModel: DetailModel? {
        didSet {
            if playModel != nil, let _ = playModel?.audioUrl {
                setTimer()
                self.setPlay()
            } else {
                // playModel이 nil이 되면 플레이어 상태 초기화
                self.isPlaying = false
                self.currentTime = 0.0
                self.duration = 0.0
            }
        }
    }
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
        timer = nil
        // 플레이어가 더 이상 필요하지 않을 때 원격 제어 이벤트가 중지되었는지 확인
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    /**타이머 세팅*/
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in // UI 업데이트가 메인 액터에서 이루어지도록 보장
                self.currentTime = await self.audioPlayer.getCurrentTime()
            }
        }
        RunLoop.current.add(timer!, forMode: .common) // 더 나은 안정성을 위해 common 런 루프 모드에 추가
    }
    
    /**오디오 첫 재생*/
    func setPlay() {
        if let audioURL = playModel?.audioUrl {
            Task { @MainActor in // UI 업데이트가 메인 액터에서 이루어지도록 보장
                do {
                    try await self.audioPlayer.setPlaySound(audioURL: audioURL, imageURL: self.playModel?.imageUrl ?? "", title: self.playModel?.title ?? "SODAM")
                    self.duration = await self.audioPlayer.getDuration()
                    self.currentTime = await self.audioPlayer.getCurrentTime() // 초기 현재 시간 가져오기
                    self.isPlaying = true
                } catch {
                    print("Error playing sound: \(error.localizedDescription)")
                    self.isPlaying = false // 오류 발생 시 isPlaying을 false로 설정
                }
            }
        }
        
    }
    /**오디오 재생*/
    func play() {
        Task { @MainActor in // UI 업데이트가 메인 액터에서 이루어지도록 보장
            await self.audioPlayer.playSound()
            self.currentTime = await self.audioPlayer.getCurrentTime() // 초기 현재 시간 가져오기
            self.isPlaying = true
        }
    }
    
    /**오디오 정지*/
    func pause() {
        Task { @MainActor in // UI 업데이트가 메인 액터에서 이루어지도록 보장
            await audioPlayer.pauseSound()
            self.isPlaying = false
        }
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
        timer?.invalidate() // 타이머 무효화
        timer = nil
        sendPlayState(state: false)
        Task {
            await audioPlayer.stopSound()
        }
    }
}

actor AudioPlayer: NSObject {
    
    var player: AVAudioPlayer?
    private let nowPlayingCenter: MPNowPlayingInfoCenter = .default()
    private let audioPlayerDelegate = AudioPlayerDelegate()
    
    private var audioSession: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }
    
    override init() {
        super.init()
    }
    
    func setPlaySound(audioURL: String, imageURL: String, title: String) async throws {
        do {
            self.stopSound()
            if player?.currentTime ?? 0 >= player?.duration ?? 0 && player?.duration ?? 0 > 0 {
                setTime(0)
            }
            
            //get audio url
            guard let audioURL = URL(string: audioURL) else {
                throw NSError(domain: "audioError", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid URL"])
            }
            
            //fetch audio data from url
            let (data, _) = try await URLSession.shared.data(from: audioURL)
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
            
            //binding player
            self.player = try AVAudioPlayer(data: data)
            guard let player = self.player else {
                throw NSError(domain: "audioError", code: 0,
                              userInfo: [NSLocalizedDescriptionKey:"Failed to initialize AVAudioPlayer"])
            }
            
            //setup delegate
            player.delegate = self.audioPlayerDelegate
            
            //begin remote control event
            await UIApplication.shared.beginReceivingRemoteControlEvents()
            
            //set remote control button actions
            MPRemoteCommandCenter.shared().playCommand.addTarget { event in
                PlayerViewModel.shared.play()
                return .success
            }
            MPRemoteCommandCenter.shared().pauseCommand.addTarget { event in
                PlayerViewModel.shared.pause()
                return .success
            }
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget { event in
                if let positionEvent = event as? MPChangePlaybackPositionCommandEvent {
                    player.currentTime = TimeInterval(positionEvent.positionTime)
                }
                return .success
            }
            MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [15.0]
            MPRemoteCommandCenter.shared().skipBackwardCommand.addTarget { [weak self] event in
                //                guard let player = self?.player else { return .commandFailed }
                let skipCommand = event as! MPSkipIntervalCommandEvent
                let newTime = player.currentTime - skipCommand.interval
                Task {
                    if player.currentTime >= 0 && player.currentTime <= player.duration && newTime >= 0 {
                        await self?.setTime(newTime)
                    } else {
                        await self?.setTime(0)
                    }
                }
                return .success
            }
            MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [15.0]
            MPRemoteCommandCenter.shared().skipForwardCommand.addTarget { [weak self] event in
                //                guard let player = self?.player else { return .commandFailed }
                let skipCommand = event as! MPSkipIntervalCommandEvent
                let newTime = player.currentTime + skipCommand.interval
                Task {
                    if player.currentTime >= 0 && newTime <= player.duration {
                        await self?.setTime(newTime)
                    } else {
                        await self?.setTime(player.duration)
                    }
                }
                return .success
            }
            
            //setup media property
            var nowPlayingInfo: [String:Any] = [:]
            
            
            //get image url
            guard let imageURL = URL(string: imageURL) else {
                throw NSError(domain: "audioError", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid URL"])
            }
            
            //fetch image data from url
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            if let image = UIImage(data: imageData) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    return image
                }
            } else if let image = UIImage(systemName: "defaultImage") {
                
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    return image
                }
            } else {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100)) { _ in
                    return UIImage()
                }
            }
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
            self.nowPlayingCenter.nowPlayingInfo = nowPlayingInfo
            
            //play audio
            player.play()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func playSound() {
        if player?.currentTime ?? 0 >= player?.duration ?? 0 && player?.duration ?? 0 > 0 {
            setTime(0)
        }
        player?.play()
        self.nowPlayingCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player?.currentTime
    }
    
    func setTime(_ time: TimeInterval) {
        self.nowPlayingCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        self.player?.currentTime = time
    }
    
    func pauseSound() {
        player?.pause()
        setTime(player?.currentTime ?? 0)
    }
    
    func stopSound() {
        do {
            player?.stop()
            self.player = nil
            nowPlayingCenter.playbackState = .stopped
            nowPlayingCenter.nowPlayingInfo?.removeAll()
            nowPlayingCenter.nowPlayingInfo = nil
            
            MPRemoteCommandCenter.shared().playCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().pauseCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().skipBackwardCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().skipForwardCommand.removeTarget(nil)
            
            //deactive current audio playback & now playing center if exists
            try self.audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getDuration() -> TimeInterval {
        return player?.duration ?? 0
    }
    
    func getCurrentTime() -> TimeInterval {
        return player?.currentTime ?? 0
    }
}

//MARK: AVAudioPlayerDelegate
final class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    override init() { super.init() }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("Audio playback finished")
        Task {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        }
        player.currentTime = 0
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0
        PlayerViewModel.shared.isPlaying = false
    }
}
