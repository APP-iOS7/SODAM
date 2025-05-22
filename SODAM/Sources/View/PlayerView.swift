import SwiftUI

struct PlayerView: View {
    
/*    MARK: 플레이어 재생 가이드(ver.0522)
    -버튼의 액션에 만들어주세요
    sendPlayState(state: true, spot: DetailModel)
 */
    var body: some View {
        VStack {
            if PlayerViewModel.shared.isLongVer {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.primaryColor.opacity(0.8))
                    .frame(height: 60)
                    .padding(5)
                    .overlay(
                        HStack {
                            AsyncImage(url: PlayerViewModel.shared.getImageURL()) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .cornerRadius(10)
                            .frame(width: 45,height: 45)
                            .onTapGesture {
                                PlayerViewModel.shared.isLongVer .toggle()
                            }
                            .padding(.leading, 13)
                            Text(PlayerViewModel.shared.getTitle())
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .padding(5)
                            Spacer()
                            
                            if PlayerViewModel.shared.isPlaying {
                                Button {
                                    PlayerViewModel.shared.pause()
                                } label: {
                                    Image(systemName: "pause.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.white)
                                        .padding(.trailing, 10)
                                        
                                }
                                Button {
                                    PlayerViewModel.shared.pause()
                                    sendPlayState(state: false)
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .foregroundStyle(Color.white)
                                        .padding(.trailing, 30)
                                }
                            } else {
                                Button {
                                    PlayerViewModel.shared.play()
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
                                AsyncImage(url: PlayerViewModel.shared.getImageURL()) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .cornerRadius(10)
                                .frame(width: 45,height: 45)
                                .onTapGesture {
                                    PlayerViewModel.shared.isLongVer.toggle()
                                }
                            }
                        )
                    Spacer()
                }
            }
        }
    }
}
