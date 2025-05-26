//
//  PlayerViewModel 2.swift
//  SODAM
//
//  Created by 최하진 on 5/23/25.
//


import Foundation
import AVFoundation

class PlayerViewModel: ObservableObject {
    static let shared = PlayerViewModel()
    
    @Published var isPlaying: Bool = false
    @Published var isLongVer: Bool = true
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
    func play() {
        audioPlayer?.play()
        self.isPlaying = true
       }
    
    /**오디오 정지*/
    func pause() {
        audioPlayer?.pause()
        self.isPlaying = false
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
}
