//
//  HomeView.swift
//  SODAM
//
//  Created by 최하진 on 5/13/25.
//

import SwiftUI
import SwiftData

struct Spot: Identifiable, Hashable {
    var title: String
    var address: String
    var position: Double
    var imageUrl: String  = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
    var audioTitle: String? = nil
    let id: UUID = UUID()
}

struct HomeView: View {
//    @Query var visitedSpots: [PlaceItem]
    @Environment(\.modelContext) private var modelContext
    let todaySpot: PlaceItem =
    PlaceItem(title: "창덕궁", mapX: "129.331719", mapY: "35.7923277", audioTitle: "고대 중세 한국사 속으로", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "서울특별시 종로구")
    
    //내 주변 관광지 배열 3개
    let nearSpots: [PlaceItem] = [
        PlaceItem(title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시", distance: 5.1),
        PlaceItem(title: "공주 공산성", mapX: "127.1266933", mapY: "36.4630408", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11173.jpg", addr1: "경상북도 경주시", distance: 5.4),
        PlaceItem(title: "재궁", mapX: "126.9946507", mapY: "37.5739916", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시", distance: 6.1),
        PlaceItem(title: "공신당", mapX: "126.9940848", mapY: "37.5742758", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/341.jpg", addr1: "경상북도 경주시", distance: 6.2)
    ]
    
    //방문한 관광지 배열 최대 5개
    let visitedSpots: [PlaceItem] = [
        PlaceItem(title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시"),
        PlaceItem(title: "공주 공산성", mapX: "127.1266933", mapY: "36.4630408", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11173.jpg", addr1: "경상북도 경주시"),
        PlaceItem(title: "재궁", mapX: "126.9946507", mapY: "37.5739916", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시"),
        PlaceItem(title: "공신당", mapX: "126.9940848", mapY: "37.5742758", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/341.jpg", addr1: "경상북도 경주시")
    ]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    //TODO: API연동
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationLink{
                        //TODO: DetailView로 연결
                    } label: {
                        AsyncImage(url: URL(string: todaySpot.imageUrl ?? "")) { image in
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
                                    Text("\(todaySpot.addr1 ?? "") | \(todaySpot.audioTitle ?? "")")
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
                        VStack {
                            Divider()
                            if !nearSpots.isEmpty {
                                ForEach(nearSpots.prefix(3)) { spot in
                                    NavigationLink{
                                        //TODO: DetailView로 연결
                                        
                                    } label: {
                                        NearSpotListCellView(spot: spot)
                                    }
                                    Divider()
                                }
                            } else {
                                Text("주변에 관광지가 없습니다.")
                                    .padding(60)
                            }
                        }
                    }
                    .frame(height: 280, alignment: .top)
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
                        if !visitedSpots.isEmpty {
                            LazyVGrid(columns: columns) {
                                ForEach(visitedSpots.prefix(5)) { spot in
                                    
                                    NavigationLink{
                                        //TODO: DetailView로 연결
                                    } label: {
                                        VisitedSpotListCellView(spot: spot)
                                    }
                                }
                            }
                        } else {
                            Text("방문한 관광지가 없습니다.")
                                .padding(30)
                        }
                    }
                    .frame(height: 130, alignment: .top)
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
    let spot: PlaceItem
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: spot.imageUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(spot.title)
                    .foregroundStyle(.black)
                    .padding(.top, 2)
                Text(spot.addr1 ?? "")
                    .font(.caption)
                    .foregroundStyle(.gray)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    if let distance = spot.distance {
                        Text("\(String(format: "%.1f", distance)) Km")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    } else {
                        Text("거리를 알 수 없습니다.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    
                }
                .padding(.top, 3)
                
            }
            .padding(.leading, 5)
            Spacer()
            
        }
    }
}

struct VisitedSpotListCellView: View {
    let spot: PlaceItem
    var body: some View {
        VStack (alignment: .center) {
            AsyncImage(url: URL(string: spot.imageUrl ?? "")) { image in
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
                Text(spot.addr1 ?? "")
                    .lineLimit(1)
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}


