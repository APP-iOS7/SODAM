//
//  PlayerViewModel.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import Foundation
import AVFoundation

class PlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var isLongVer: Bool = true
    @Published var audioUrl: String
    @Published var audioData: Data?
    
    var audioPlayer: AVPlayer?
    init(url: String) {
        self.audioUrl = url
        setPlayer()
    }

    private func setPlayer() {
        do {
            // 무음모드에서도 재생되도록 설정
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화. 앱이 백그라운드로 이동하거나 중단되었을 때, 다시 활성화해야함
            guard let url = URL.init(string: audioUrl) else { return }
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer.init(playerItem: playerItem)
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    func play() {
        audioPlayer?.play()
        self.isPlaying = true
       }

    func pause() {
        audioPlayer?.pause()
        self.isPlaying = false
    }

}
