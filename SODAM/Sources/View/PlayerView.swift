//
//  PlayerView.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import SwiftUI

struct PlayerView: View {
    @AppStorage("playerState") var playerState: Bool = UserDefaults.standard.bool(forKey: "playerState")
    
    @StateObject var playerViewModel: PlayerViewModel
    
/*    MARK: 플레이어 재생 가이드(ver.0521)
 1. 뷰에서 변수 세팅
 @AppStorage("playerTitle") var playerTitle: String = (UserDefaults.standard.string(forKey: "playerTitle") ?? "")
 @AppStorage("playerImageURL") var playerImageURL: String = (UserDefaults.standard.string(forKey: "playerImageURL") ?? "")
 @AppStorage("playerAudioURL") var playerAudioURL: String = (UserDefaults.standard.string(forKey: "playerAudioURL") ?? "")
 
2. 재생을 위한 변수 전달(버튼의 액션이나 함수로 만들어주세요)
 playerTitle = 오디오 제목
 playerImageURL = 이미지 URL
 playerAudioURL = 오디오 URL
 sendPlayState(state: true)
 */
    var body: some View {
        VStack {
            if playerViewModel.isLongVer {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.primaryColor.opacity(0.8))
                    .frame(height: 60)
                    .padding(5)
                    .overlay(
                        HStack {
                            AsyncImage(url: playerViewModel.getImageURL()) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .cornerRadius(10)
                            .frame(width: 45,height: 45)
                            .onTapGesture {
                                playerViewModel.isLongVer .toggle()
                            }
                            .padding(.leading, 13)
                            Text(playerViewModel.getTitle())
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .padding(5)
                            Spacer()
                            
                            if playerViewModel.isPlaying {
                                Button {
                                    playerViewModel.pause()
                                } label: {
                                    Image(systemName: "pause.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.white)
                                        .padding(.trailing, 10)
                                        
                                }
                                Button {
                                    //TODO: 플레이어 닫기 함수
                                    playerViewModel.pause()
                                    sendPlayState(state: false)
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .foregroundStyle(Color.white)
                                        .padding(.trailing, 30)
                                }
                            } else {
                                Button {
                                    playerViewModel.play()
                                } label: {
                                    Image(systemName: "play.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.white)
                                        .padding(.trailing, 30)
                                }
                            }
                        }
                    )
            } else {
                HStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.primaryColor.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .padding(5)
                        .overlay(
                            HStack {
                                AsyncImage(url: playerViewModel.getImageURL()) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .cornerRadius(10)
                                .frame(width: 45,height: 45)
                                .onTapGesture {
                                    playerViewModel.isLongVer.toggle()
                                }
                            }
                        )
                    Spacer()
                }
            }
        }
    }
}

//#Preview {
//    PlayerView(playerViewModel: PlayerViewModel(title: playerTitle, imageUrl: playerImageURL, audioUrl: playeraudioURL))
//}
