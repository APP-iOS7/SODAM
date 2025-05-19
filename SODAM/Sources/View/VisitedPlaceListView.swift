//
//  VisitedPlaceListView.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//

//VisitedPlaceListView

import SwiftUI
import SwiftData

public struct VisitedPlaceListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var testViewModel = VisitedPlacesViewModel()

    
    public var body: some View {
        VStack {
            if let testData = testViewModel.listItems.first {
                Text("🩷\(testData)")
            } else {
                Text("테스트 데이터를 불러오는 중입니다.")
            }
        }
        .onAppear {
            testViewModel.setContext(modelContext)
            //fetchDummyData()
            //testViewModel.fetchItems()
            testViewModel.fetchGroupedItemsByLocation()
            // print("🩷\(testViewModel.items.count)")
        }
    }
    
    private func fetchDummyData() {
        let items = [
            PlaceItem(title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg"),
            PlaceItem(title: "공주 공산성", mapX: "127.1266933", mapY: "36.4630408", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11173.jpg"),
            PlaceItem(title: "재궁", mapX: "126.9946507", mapY: "37.5739916", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg"),
            PlaceItem(title: "공신당", mapX: "126.9940848", mapY: "37.5742758", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/341.jpg")
        ]
        for item in items {
            testViewModel.addItem(item:item)
        }
    }
}
