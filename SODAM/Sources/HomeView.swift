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
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationLink{
                        //TODO: DetailView로 연결
                    } label: {
                        TodaySpotView(spot: homeViewModel.GetTodaySpot())
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
                            if !homeViewModel.IsNearSpotEmpty() {
                                ForEach(homeViewModel.GetNearSpots()) { spot in
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
                        if !homeViewModel.IsVisitedSpotEmpty() {
                            LazyVGrid(columns: homeViewModel.columns) {
                                ForEach(homeViewModel.GetVisitedSpots()) { spot in
                                    
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



struct TodaySpotView: View {
    let spot: PlaceItem
    var body: some View {
        AsyncImage(url: URL(string: spot.imageUrl ?? "")) { image in
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
                    Text(spot.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 5)
                    Text("\(spot.addr1 ?? "") | \(spot.audioTitle ?? "")")
                        .font(.caption)
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 10)
                }
                .padding(.leading, 20)
                Spacer()
            }
        )
    }
}
