import SwiftUI

struct PlayerView: View {
    
/*    MARK: 플레이어 재생 가이드(ver.0522)
    -버튼의 액션에 만들어주세요
    sendPlayState(state: true, spot: DetailModel)
 */
    @StateObject var playerViewModel = PlayerViewModel.shared
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
                                playerViewModel.isLongVer = false
                            }
                            .padding(.leading, 13)
                            Text(playerViewModel.getTitle())
                                .lineLimit(1)
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

                            } else {
                                Button {
                                    playerViewModel.play()
                                } label: {
                                    Image(systemName: "play.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.white)
                                        .padding(.trailing, 10)
                                }
                            }
                            Button {
                                playerViewModel.close()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title3)
                                    .foregroundStyle(Color.white)
                                    .padding(.trailing, 30)
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
                                    playerViewModel.isLongVer = true
                                }
                            }
                        )
                    Spacer()
                }
            }
        }
    }
}
