//
//  DetailView.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//
//  장소 상세화면

import SwiftUI

public struct DetailView: View {
    
    @State private var selectedTab: DetailHeaderView.Tab = .photo
    @State private var keyword: String = "송파"
    
    @StateObject private var viewModel = DetailViewModel()
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DetailHeaderView(selectedTab: $selectedTab)
            ScrollView {
                if let firstItem = viewModel.items?.first {
                    DetailImageView(url: firstItem.imageUrl ?? "")
                    DetailInfoView(model: firstItem)
                } else {
                    Text("데이터를 불러오는 중입니다.")
                }
            }
            .padding(8)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            viewModel.fetchDetailInfo(keyword: keyword)
            // viewModel.fetch()
        }
    }
}

#Preview {
    DetailView()
}

// MARK: segmented control UI
struct DetailHeaderView: View {
    @Binding var selectedTab: Tab
    
    enum Tab {
        case photo
        case map
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Button(action: {
                    selectedTab = .photo
                    print("clicked photo")
                }) {
                    Text("사진")
                        .foregroundColor(selectedTab == .photo ? .black : .gray)
                        .fontWeight(selectedTab == .photo ? .bold : .regular)
                        .frame(maxWidth: .infinity)
                }
                Rectangle()
                    .fill(selectedTab == .photo ? Color.green : Color.clear)
                    .frame(height: 4)
            }
            
            VStack {
                Button(action: {
                    selectedTab = .map
                    print("clicked map")
                }) {
                    Text("지도")
                        .foregroundColor(selectedTab == .map ? .black : .gray)
                        .fontWeight(selectedTab == .map ? .bold : .regular)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.red.opacity(0.1))
                Rectangle()
                    .fill(selectedTab == .map ? Color.green : Color.clear)
                    .frame(height: 4)
            }
        }
        .frame(height: 44)
    }
}

// MARK: 장소 이미지
struct DetailImageView: View {
    var url: String
    
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
    var model: DetailModel
    var body: some View {
        HStack {
            let distance = haversineDistance(
                lat1: 37.4981, lon1: 126.9220, // 서울
                lat2: Double(model.mapY ?? "37.5") ?? 37.5, lon2: Double(model.mapX ?? "126.9") ?? 126.9
            )
            
            let km = String(format: "%.2f", distance)
            Text("나와의 거리 \(km)km")
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
    let model: DetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(model.title ?? "")
                .font(.system(size: 24, weight: .bold))
                .padding([.top], 8)
            if let addr1 =  model.addr1 {
                Text("\(model.addr1 ?? "") \(model.addr2 ?? "")")
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
