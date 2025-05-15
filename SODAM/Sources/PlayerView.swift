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
    @State var isAudioOn: Bool = false
    @State var isLongVer: Bool = true
    var body: some View {
        VStack {
            if isLongVer {
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
                                isLongVer.toggle()
                            }
                            .padding(.leading, 13)
                            Text(spot.title)
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .padding(5)
                            Spacer()
                            
                            if isAudioOn {
                                Button {
                                    playerViewModel.pause()
                                    isAudioOn.toggle()
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
                                    isAudioOn.toggle()
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
                                    isLongVer.toggle()
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
