//
//  HomeViewModel.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import Foundation
import SwiftData
import SwiftUI

class HomeViewModel: ObservableObject {
//    @Query var visitedSpots: [PlaceItem]
    @Environment(\.modelContext) private var modelContext
    
    @Published var todaySpot: PlaceItem
    @Published var nearSpots: [PlaceItem]
    @Published var visitedSpots: [PlaceItem]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    init() {
        self.todaySpot = PlaceItem(title: "", mapX: "", mapY: "")
        self.nearSpots = [
            PlaceItem(title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시", distance: 5.1),
            PlaceItem(title: "공주 공산성", mapX: "127.1266933", mapY: "36.4630408", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11173.jpg", addr1: "경상북도 경주시", distance: 5.4),
            PlaceItem(title: "재궁", mapX: "126.9946507", mapY: "37.5739916", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시", distance: 6.1),
            PlaceItem(title: "공신당", mapX: "126.9940848", mapY: "37.5742758", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/341.jpg", addr1: "경상북도 경주시", distance: 6.2)
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
    func GetNearSpots() -> [PlaceItem] {
        return Array(nearSpots.prefix(3))
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
