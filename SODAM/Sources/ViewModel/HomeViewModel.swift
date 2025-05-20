//
//  HomeViewModel.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import Foundation
import SwiftData
import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {
//    @Query var visitedSpots: [PlaceItem]
    @Environment(\.modelContext) private var modelContext
    
    @Published var todaySpot: PlaceItem
    @Published var nearSpots: [DetailModel]
    @Published var visitedSpots: [PlaceItem]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    init() {
        self.todaySpot = PlaceItem(title: "", mapX: "", mapY: "")
        self.nearSpots = [
            DetailModel(tid: nil, tlid: nil, stid: nil, stlid: nil, themeCategory: nil, category: nil, addr1: "경상북도 경주시", addr2: nil, title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", audioTitle: nil, script: nil, playTime: nil, audioUrl: nil, langCheck: nil, langCode: nil, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", createdTime: nil, modifiedtime: nil)
        ]
        self.visitedSpots = [
            PlaceItem(title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시"),
            PlaceItem(title: "공주 공산성", mapX: "127.1266933", mapY: "36.4630408", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11173.jpg", addr1: "경상북도 경주시"),
            PlaceItem(title: "재궁", mapX: "126.9946507", mapY: "37.5739916", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시"),
            PlaceItem(title: "공신당", mapX: "126.9940848", mapY: "37.5742758", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/341.jpg", addr1: "경상북도 경주시")
        ]
    }
    
    func GetTodaySpot() -> PlaceItem {
        return PlaceItem(title: "창덕궁", mapX: "129.331719", mapY: "35.7923277", audioTitle: "고대 중세 한국사 속으로", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "서울특별시 종로구")
    }
    
    func GetNearSpots() async {
        //    let userLat = UserLocation.shared.userLat
        //    let userLon = UserLocation.shared.userLon
            let userLat = 37.4981
            let userLon = 126.9220
        Task {
            do {
                nearSpots = try await APIService.shared.getThemeLocationBasedList(lng: userLon, lat: userLat, radius: 10000, numOfRows: 3, pageNo: 1)
                
            } catch {
                print("getThemeLocationBasedList ERROR: ", error)
            }
        }
    }
    
    func GetVisitedSpots() -> [PlaceItem] {
        return Array(visitedSpots.prefix(5))
    }
    func IsNearSpotEmpty() -> Bool {
        return nearSpots.isEmpty
    }
    func IsVisitedSpotEmpty() -> Bool {
        return visitedSpots.isEmpty
    }
}

func GetDistance(spot: DetailModel) -> Double? {
//    let userLat = UserLocation.shared.userLat
//    let userLon = UserLocation.shared.userLon
    let userLat = 37.4981
    let userLon = 126.9220
    print("\(spot.mapX) \(spot.mapY)")
    print(Double(spot.mapX) ?? 0)
    return haversineDistance(lat1: userLat, lon1: userLon, // 서울
        lat2: Double(spot.mapY) ?? 37.5, lon2: Double(spot.mapX) ?? 126.9
    )
}
