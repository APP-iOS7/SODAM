//
//  PlayerView.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import SwiftUI

struct PlayerView: View {
    
    let spot: Spot = Spot(title: "창덕궁", address: "서울특별시 종로구", position: 0.0, audioTitle: "고대 중세 한국사 속으로")
    @StateObject var playerViewModel = PlayerViewModel(url:   "https://sfj608538-sfj608538.ktcdn.co.kr/file/audio/56/998.mp3")

//    TODO: UserDefaults에 오디오 플레이어 On/Off상태 두고 그에 따라 오디오 플레이어 가져오기
//    @State private var isAudioPlayerOn = UserDefaults.standard.integer(forKey: "AudioPlayer")
//    UserDefaults.standard.set(true, forKey: "AudioPlayer")
    var body: some View {
        VStack {
            if playerViewModel.isLongVer {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.primaryColor.opacity(0.8))
                    .frame(height: 60)
                    .padding(5)
                    .overlay(
                        HStack {
                            AsyncImage(url: URL(string: spot.imageUrl)) { image in
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
                            Text(spot.title)
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
                                AsyncImage(url: URL(string: spot.imageUrl)) { image in
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

#Preview {
    PlayerView()
}
