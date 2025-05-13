//
//  DetailView.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//
//  장소 상세화면

import SwiftUI

public struct DetailView: View {
    
    let sample = """
돌담 너머로 보이는 창덕궁 북촌 여행의 재미 중 하나는 북촌의 가장 아름다운 경치 8곳을 지정해놓은 ‘북촌 8경’을 돌아보는 것입니다. 그러면 북촌 1경부터 먼저 찾아가 볼까요? 북촌 1경은 돌담 너머로 보이는 ‘창덕궁 전경’입니다. 북촌문화센터를 지나 위로 올라가다 보면 작은 사거리가 나타납니다. 사거리 오른쪽 언덕이 창덕궁으로 이어지는 길인데요. 언덕 꼭대기가 가까워지면 마치 숨겨진 선물처럼 창덕궁이 서서히 모습을 드러냅니다. 담장 너머로 가장 먼저 보이는 높은 건물은 왕들이 정무를 보았던 창덕궁의 정전인 ‘인정전’의 측면입니다. 그 앞으로 보이는 것은 왕실의 도서관과 연구소 역할을 했던 ‘규장각’ 건물들과 선대 왕들의 초상화를 모시고 제사를 지내던 ‘선원전’입니다. 창덕궁은 경복궁에 이어 조선왕조에서 두 번째로 지어진 궁궐로 왕들이 가장 오래 머물렀던 곳입니다. 1997년에는 유네스코 세계문화유산에 등재되기도 했는데요. 조선의 여러 궁궐 중에서 창덕궁이 유일하게 유네스코 세계문화유산에 등재된 이유가 궁금하지 않으세요? 과거 왕들은 궁궐을 질서정연하고 웅장하게 지어서 왕실의 권위를 세우려고 했답니다. 중국의 자금성이 대표적인 예라고 할 수 있어요. 조선의 첫 번째 궁궐인 경복궁도 각 건물이 일직선 상에 좌우대칭으로 놓여 질서정연합니다. 하지만 창덕궁은 높낮이가 다른 자연 그대로의 지형을 유지한 채 건물을 지었기 때문에 자연과 아름다운 조화를 이루고 있습니다. 조선의 궁궐 중 원형이 가장 잘 보존된 곳이기도 하지요. 이 때문에 우리나라 궁궐로서는 처음으로 유네스코 세계문화유산에 등재된 것입니다. 또한 창덕궁은 왕과 왕비들이 특히 사랑했던 궁궐이라고 합니다. 경복궁은 왕의 처소와 집무 공간이 가까워 좁은 공간만을 계속 왔다 갔다 해야 했지만 창덕궁은 왕이 쉴 수 있는 정원을 넓게 만들어 한결 여유로웠기 때문이라고 하네요. 그래서 조선 전기의 왕 중 정사를 돌보는 데에 특히 온 힘을 쏟았던 세종대왕을 제외하고는 대부분 경복궁보다 창덕궁을 더 좋아했다는 이야기가 전해집니다.
"""
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                DetailHeaderView()
                DetailImageView()
                DetailInfoView(sampleText: sample)
            }
            .padding(8)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    DetailView()
}

// MARK: segmented control UI
struct DetailHeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Button("사진") {}
                Rectangle()
                    .foregroundStyle(Color.gray)
                    .frame(height: 4)
            }
            VStack {
                Button("지도") {}
                Rectangle()
                    .foregroundStyle(Color.green)
                    .frame(height: 4)
            }
        }
        .frame(height: 44)
    }
}

// MARK: 장소 이미지
struct DetailImageView: View {
    var url: String = "https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqQY2z1Dwhi0P9Mts8qKbXRyCKDQrEuq8xp_D-vG78C0CFqs3XYLzWgUqio7MfSFoxyIw5wkoSFI-HGQqvu8cR3Jlka5I0hJ_xyTCBBHu_XuAVaarjmskwIgi7wpbv1tlEfpNLb=w270-h312-n-k-no"
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray
        }
        .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
        .clipped()
    }
}

// MARK: 장소 이름, 주소, 거리, 버튼 영역
struct DetailButtonView: View {
    var body: some View {
        HStack {
            Text("나와의 거리 00km")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.green)
            Spacer()
            HStack(spacing: 12) {
                Button {
                    print("play button clicked")
                    // TODO: 플레이어 재생
                } label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .foregroundStyle(.green)
                
                Button {
                    print("share button clicked")
                    // TODO: 공유하기 기능 활성화
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

// MARK: script영역
struct DetailInfoView: View {
    let sampleText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("장소 이름")
                .font(.system(size: 24, weight: .bold))
            Text("00시 00구 00로 123045")
                .font(.system(size: 12))
            DetailButtonView()
            Text(sampleText.byCharWrapping)
                .padding(.vertical, 8)
        }
    }
}

// MARK: 문장을 단어별로 끊지 않고, 문자별로 끊어서 표시
extension String {
    var byCharWrapping: Self {
        map(String.init).joined(separator: "\u{200B}")
    }
}
