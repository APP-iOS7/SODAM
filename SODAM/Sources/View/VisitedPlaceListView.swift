//
//  VisitedPlaceListView.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//

//VisitedPlaceListView

import SwiftUI
import SwiftData

struct VisitedPlaceListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = VisitedPlacesViewModel()
    
    var body: some View {
        VStack {
            SegmentControlsComponent(selectSegment: $viewModel.selectSegment)
            switch viewModel.selectSegment {
            case .list:
                if viewModel.isLoading {
                    loadingView
                } else {
                    if viewModel.listItems.isEmpty {
                        isEmptyView
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                ForEach(viewModel.listItems, id: \.self) { item in
                                    placeItemList(listItems: item)
                                }
                            }.padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            case .map:
                ScrollView {
                    Text("Map Page")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setContext(modelContext)
            //fetchDummyData()
            viewModel.fetchGroupedItemsByLocation()
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
            viewModel.addItem(item:item)
        }
    }
    
    // MARK: isLoading이 true일 동안의 View
    private var loadingView: some View {
        VStack {
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: regionList에 데이터가 없을 경우
    private var isEmptyView: some View {
        VStack {
            Text("데이터가 없습니다 ㅠ..ㅠ")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func placeItemList(listItems: [PlaceItem]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let locationName = listItems.first?.loc {
                Text(locationName)
                    .font(Font.system(size: 20, weight: .bold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(listItems) { item in
                            // MARK: 상세화면으로 모델링 해서 이동
                            let detailItem = DetailModel(tid: nil, tlid: nil, stid: nil, stlid: nil, themeCategory: nil, category: nil, addr1: item.addr1, addr2: item.addr2, title: item.title, mapX: item.mapX, mapY: item.mapY, audioTitle: item.audioTitle, script: item.script, playTime: item.playTime, audioUrl: item.audioURL, langCheck: nil, langCode: item.lanCode, imageUrl: item.imageUrl, createdTime: nil, modifiedtime: nil)
                            NavigationLink(destination: DetailView(item: detailItem )) {
                                placeItem(item: item)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 지역 관광지 각 Row
    private func placeItem(item: PlaceItem) -> some View {
        return AnyView(
            VStack(spacing: 8) {
                Spacer()
                    .frame(height: 8)
                // 원형 이미지
                AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .frame(width: 80, height: 80)
                    } else {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .shadow(radius: 3)
                )
                Spacer()
                // 관광지 이름
                Text(item.title)
                    .foregroundStyle(Color.black)
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                    .frame(height: 8)
            }
            .frame(maxWidth: 100, maxHeight: 120)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .stroke(Color.black40, lineWidth: 1)
                )
            )
        }
}

#Preview {
    VisitedPlaceListView()
}
