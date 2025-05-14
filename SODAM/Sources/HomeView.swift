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
    let imageUrl: String = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
    let nearSpots: [Spot] = [Spot(name: "안산 대부도", address: "경기도 안산시", position: 54.8),Spot(name: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(name: "오이도", address: "경기도 사흥시", position: 38.7)]
    let visitedSpots: [Spot] = [Spot(name: "안산 대부도", address: "경기도 안산시", position: 54.8),Spot(name: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(name: "오이도", address: "경기도 사흥시", position: 38.7),Spot(name: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(name: "오이도", address: "경기도 사흥시", position: 38.7)]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250)
                .background(
                    
                )
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
                            NearSpotListCellView(spot: spot)
                        }
                    }
                }
                .padding(15)
                
                VStack {
                    HStack {
                        Text("방문한 관광지")
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
                    LazyVGrid(columns: columns) {
                        ForEach(visitedSpots) { spot in
                            VisitedSpotListCellView(spot: spot)
                        }
                    }
                }
                .padding([.leading,.trailing], 15)
            }
        }
    }
}

#Preview {
    HomeView()
}

struct NearSpotListCellView: View {
    let spot: Spot
    let imageUrl: String = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
    var body: some View {
        HStack(alignment: .top) {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
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

struct VisitedSpotListCellView: View {
    let spot: Spot
    let imageUrl: String = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
    var body: some View {
        VStack (alignment: .center) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(100)
                
            VStack(alignment: .center) {
                Text(spot.name)
                    .lineLimit(1)
                    .font(.caption)
                Text(spot.address)
                    .lineLimit(1)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}
