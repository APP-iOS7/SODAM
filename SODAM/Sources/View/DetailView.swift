//
//  DetailView.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//
//  장소 상세화면

import SwiftUI
import SwiftData
import KakaoMapsSDK
import CoreLocation

enum Tab: String {
    case photo = "사진"
    case map = "지도"
}

public struct DetailView: View {
    @State private var selectedTab: Tab = .photo
    private let regionLocation: CLLocationCoordinate2D?
    private var item: DetailModel?
    
    init(item: DetailModel? = nil) {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
        } else {
            print("Kakao App Key is missing in Info.plist")
        }
        self.item = item
        if let latitude = Double(item?.mapX ?? ""), let longitude = Double(item?.mapY ?? "") {
            self.regionLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.regionLocation = nil
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DetailHeaderView(selectedTab: $selectedTab)
            ScrollView(.vertical, showsIndicators: false) { // scroll Indicator 숨기기
                if let detailItem = item {
                    DetailImageView(url: detailItem.imageUrl ?? "", selectedTab: $selectedTab)
                    DetailInfoView(model: detailItem)
                } else {
                    Text("데이터가 없습니다.")
                }
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
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            segmentButton(type: .photo, isActive: selectedTab == .photo)
            segmentButton(type: .map, isActive: selectedTab == .map)
        }
        .frame(height: 44)
    }
    
    private func segmentButton(type: Tab, isActive: Bool) -> some View {
        VStack {
            Button(action: {
                selectedTab = type
                print("clicked \(type.rawValue)")
            }) {
                Text("\(type.rawValue)")
                    .foregroundColor(isActive ? Color.textColor : .gray)
                    .fontWeight(isActive ? .bold : .regular)
                    .frame(maxWidth: .infinity)
            }
            Rectangle()
                .fill(isActive ? Color.green : Color.clear)
                .frame(height: 4)
        }
    }
}

// MARK: 장소 이미지
struct DetailImageView: View {
    var url: String
    @Binding var selectedTab: Tab
    
    var body: some View {
        if selectedTab == .photo {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
            .clipped()
        } else {
            // TODO: 지도 영역 연동
            Rectangle()
                .foregroundStyle(Color.secondaryColorRed)
                .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
                .clipped()
        }
            
    }
}

// MARK: 장소 이름, 주소, 거리, 버튼 영역
struct DetailButtonView: View {
    var model: DetailModel
    var body: some View {
        HStack {
            let distance = haversineDistance(
                lat1: 37.4981, lon1: 126.9220, // 서울
                lat2: Double(model.mapY) ?? 37.5, lon2: Double(model.mapX) ?? 126.9
            )
            
            let km = String(format: "%.2f", distance)
            Text("나와의 거리 \(km)km")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.green)
            Spacer()
            HStack(spacing: 12) {
                // audioURL 있을때만 활성화
                if let audioUrl = model.audioUrl {
                    Button {
                        print("play button clicked")
                        // TODO: 플레이어 재생
                        sendPlayState(state: true, spot: model)
                    } label: {
                        Image(systemName: "play.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                    .foregroundStyle(.green)
                }
                
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
    let model: DetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(model.title)
                .font(.system(size: 24, weight: .bold))
                .padding([.top], 8)
            if let addr1 =  model.addr1 {
                Text("\(addr1) \(model.addr2 ?? "")")
                    .font(.system(size: 12))
            }
            DetailButtonView(model: model)
            Text((model.script ?? "").byCharWrapping)
                .padding(.vertical, 16)
        }
    }
}

// private func testButton(text: String,iconName: String ) -> some View{

// MARK: 문장을 단어별로 끊지 않고, 문자별로 끊어서 표시
extension String {
    var byCharWrapping: Self {
        map(String.init).joined(separator: "\u{200B}")
    }
}

// MARK: 위경도로 두점 사이 거리 구하기
func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    let R = 6371.0 // 지구 반지름 (단위: km)

    let dLat = (lat2 - lat1).degreesToRadians
    let dLon = (lon2 - lon1).degreesToRadians

    let a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) *
            sin(dLon / 2) * sin(dLon / 2)

    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    let distance = R * c
    return distance
}

extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180
    }
}
