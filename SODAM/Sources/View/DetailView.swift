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
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Tab = .photo
    @State private var draw: Bool = false
    
    private var regionLocation: CLLocationCoordinate2D?
    private var item: DetailModel?
    
    // detailView 초기화
    init(item: DetailModel? = nil) {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
        } else {
            print("Kakao App Key is missing in Info.plist")
        }
        self.item = item
        if let latitude = Double(item?.mapY ?? ""), let longitude = Double(item?.mapX ?? "") {
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
                    DetailImageView(url: detailItem.imageUrl ?? "", regionLocation: regionLocation, selectedTab: $selectedTab, draw: $draw)
                    DetailInfoView(model: detailItem)
                } else {
                    Text("데이터가 없습니다.")
                }
            }
            .padding(8)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            draw = true
            //print(item?.script ?? "")
        }
        .onDisappear { draw = false }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(Color.primaryColor)
                .onTapGesture {
                    dismiss()
                }
            }
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
            segmentButton(type: .photo)
            segmentButton(type: .map)
        }
        .frame(height: 44)
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)) // 좌우 패딩
    }
    
    private func segmentButton(type: Tab) -> some View {
        Button(action: {
            withAnimation { selectedTab = type }
        }) {
            VStack {
                Text("\(type.rawValue)")
                    .foregroundColor(selectedTab == type ? Color.textColor : .gray)
                    .fontWeight(selectedTab == type ? .bold : .regular)
                    .frame(maxWidth: .infinity)
                Rectangle()
                    .fill(selectedTab == type ? Color.green : Color.clear)
                    .frame(height: 4)
                    .cornerRadius(2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: 장소 이미지
struct DetailImageView: View {
    var url: String
    var regionLocation: CLLocationCoordinate2D?
    
    @Binding var selectedTab: Tab
    @Binding var draw: Bool
    
    var body: some View {
        ZStack {
            if selectedTab == .photo {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Color.gray
                            .overlay(Text("이미지를 불러올 수 없습니다.").foregroundColor(.white))
                    @unknown default:
                        Color.gray
                    }
                }
            } else {
                KakaoMapView(
                    draw: $draw,
                    markerCoordinate: CLLocationCoordinate2D(
                        latitude: regionLocation?.latitude ?? 0.0,
                        longitude: regionLocation?.longitude ?? 0.0
                    ),
                    userDotImage: UIImage(named: "mapPin")
                )
            }
        }
        .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
        .clipped()
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.bottom, 8)
    }
}


// MARK: 장소 이름, 주소, 거리, 버튼 영역
struct DetailButtonView: View {
    var model: DetailModel
    var body: some View {
        HStack {
            let distance = haversineDistance(
                lat1: UserLocation.shared.userLat, lon1: UserLocation.shared.userLon,
                lat2: Double(model.mapY) ?? 37.5, lon2: Double(model.mapX) ?? 126.9
            )
            
            let km = String(format: "%.2f", distance)
            Text("나와의 거리 \(km)km")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.green)
            Spacer()
            HStack(spacing: 12) {
                // audioURL 있을때만 활성화
                if let audioUrl = model.audioUrl {
                    Button {
                        print("play button clicked")
                        sendPlayState(state: true, spot: model)
                    } label: {
                        Image(systemName: "play.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    .foregroundStyle(.green)
                }
                
                /*
                Button {
                    print("share button clicked")
                 // TODO: 공유하기 기능 활성화
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(.black)
                 */
            }
        }
    }
}

// MARK: script영역
struct DetailInfoView: View {
    let model: DetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(model.title.replacingOccurrences(of: "(초등 교과연계)", with: ""))
                .font(.system(size: 24, weight: .bold))
                .padding([.top], 8)
            if let addr1 =  model.addr1 {
                Text("\(addr1) \(model.addr2 ?? "")")
                    .font(.system(size: 16))
            }
            DetailButtonView(model: model)
            
            let decoded = (model.script ?? "")
                .replacingOccurrences(of: #"\t"#, with: "\n")
                .replacingOccurrences(of: #" {2,}"#, with: "\n\n", options: .regularExpression)
                .replacingOccurrences(of: #"\u003c"#, with: "<")
                .replacingOccurrences(of: #"\u003e"#, with: ">")

            Text(decoded.byCharWrapping)
                .font(.system(size: 18))
                .padding(.vertical, 16)
                .lineSpacing(8) // 줄 간격 늘림
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
