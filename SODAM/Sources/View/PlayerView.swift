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
                    .fill(Color.primaryColor)
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
                            VStack(alignment: .leading) {
                                Text("aa")
                                    .lineLimit(1)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.white)
                                    .padding([.trailing, .top], 5)
                                HStack {
                                    ProgressView(value: playerViewModel.currentTime, total: playerViewModel.duration)
                                        .progressViewStyle(.linear)
                                        .tint(Color.white)
                                    Text(formatTime(playerViewModel.duration))
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                }
                                .padding(.top, -7)
                            }
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
                                    .fontWeight(.bold)
                                    .font(.title2)
                                    .foregroundStyle(Color.white)
                                    .padding(.trailing, 30)
                            }
                        }
                    )
            } else {
                HStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.primaryColor)
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
        .onChange(of: playerViewModel.currentTime, {
            if playerViewModel.currentTime == playerViewModel.duration {
                playerViewModel.pause()
            }
        })
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", min, sec)
    }
}

#Preview {
    PlayerView(playerViewModel: PlayerViewModel())
}
