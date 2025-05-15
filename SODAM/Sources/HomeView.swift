//
//  HomeView.swift
//  SODAM
//
//  Created by 최하진 on 5/13/25.
//

import SwiftUI
struct Spot: Identifiable, Hashable {
    var title: String
    var address: String
    var position: Double
    var imageUrl: String  = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
    var audioTitle: String? = nil
    let id: UUID = UUID()
}
struct HomeView: View {
    let todaySpot: Spot = Spot(title: "창덕궁", address: "서울특별시 종로구", position: 0.0, audioTitle: "고대 중세 한국사 속으로")
    
    //내 주변 관광지 배열 3개
    let nearSpots: [Spot] = [Spot(title: "안산 대부도", address: "경기도 안산시", position: 54.8),Spot(title: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(title: "오이도", address: "경기도 사흥시", position: 38.7)]
    
    //방문한 관광지 배열 최대 5개
    let visitedSpots: [Spot] = [Spot(title: "안산 대부도", address: "경기도 안산시", position: 54.8),Spot(title: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(title: "오이도", address: "경기도 사흥시", position: 38.7),Spot(title: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),Spot(title: "오이도", address: "경기도 사흥시", position: 38.7)]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    //TODO: API연동
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationLink{
                        //TODO: DetailView로 연결
                    } label: {
                        AsyncImage(url: URL(string: todaySpot.imageUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 250)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("오늘의 이야기")
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                        .padding(.top, 10)
                                    Spacer()
                                    Text(todaySpot.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, 5)
                                    Text("\(todaySpot.address) | \(todaySpot.audioTitle ?? "")")
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, 10)
                                }
                                .padding(.leading, 20)
                                Spacer()
                            }
                        )
                    }
                    
                    
                    VStack {
                        HStack {
                            Text("내 주변 관광지")
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink{
                                //TODO: 전체보기 목록뷰으로 연결
                            } label: {
                                Text("전체보기")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        Grid {
                            ForEach(nearSpots) { spot in
                                NavigationLink{
                                    //TODO: DetailView로 연결
                                } label: {
                                    NearSpotListCellView(spot: spot)
                                }
                            }
                        }
                    }
                    .padding(15)
                    
                    VStack {
                        HStack {
                            Text("방문한 관광지")
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink{
                                //TODO: 전체보기 목록뷰으로 연결
                            } label: {
                                Text("전체보기")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        LazyVGrid(columns: columns) {
                            ForEach(visitedSpots) { spot in
                                
                                NavigationLink{
                                    //TODO: DetailView로 연결
                                } label: {
                                    VisitedSpotListCellView(spot: spot)
                                }
                            }
                        }
                    }
                    .padding([.leading,.trailing], 15)
                    
                    //TODO: 조건문 필요-Player가 켜져있을 떄만 필요한 부분입니다.
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.clear)
                        .frame(height: 20)
                        .padding(5)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

struct NearSpotListCellView: View {
    let spot: Spot
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: spot.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(spot.title)
                    .foregroundStyle(.black)
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
    var body: some View {
        VStack (alignment: .center) {
            AsyncImage(url: URL(string: spot.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(100)
            
            VStack(alignment: .center) {
                Text(spot.title)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Text(spot.address)
                    .lineLimit(1)
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}


