//
//  HomeView.swift
//  SODAM
//
//  Created by 최하진 on 5/13/25.
//

import SwiftUI
struct Spot: Identifiable {
    let name: String
    let address: String
    let position: Double
    let id: UUID = UUID()
}
struct HomeView: View {
    let name: String = "창덕궁"
    let address: String = "서울특별시 종로구"
    let title: String = "고대 중세 한국사 속으로"
    let nearSpots: [Spot] = [Spot(name: "안산 대부도", address: "경기도 안산시", position: 54.8),Spot(name: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(name: "오이도", address: "경기도 사흥시", position: 38.7)]
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .frame(height: 250)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("오늘의 이야기")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .padding(.top, 10)
                        Spacer()
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 5)
                        Text("\(address) | \(title)")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 10)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
            )
        
        VStack {
            HStack {
                Text("내 주변 관광지")
                    .fontWeight(.bold)
                Spacer()
                Button {
                    //TODO: 전체보기로 네비게이션
                    print("click 전체보기")
                } label: {
                    Text("전체보기")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
            }
            Grid {
                ForEach(nearSpots) { spot in
                    GridListCellView(spot: spot)
                }
            }
        }
        .padding(15)
    }
}

#Preview {
    HomeView()
}

struct GridListCellView: View {
    let spot: Spot
    var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 70, height: 70)
            VStack(alignment: .leading) {
                Text(spot.name)
                Text(spot.address)
                    .font(.caption)
                    .foregroundStyle(.gray)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    Text("\(String(format: "%.1f", spot.position)) Km")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 3)
                
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}
