//
//  VisitedPlaceListView.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//
// VisitedPlaceListView

import SwiftUI
import SwiftData
import KakaoMapsSDK
import CoreLocation

struct VisitedPlaceListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = VisitedPlacesViewModel()
    @State private var draw: Bool = false
    
    init() {
        // kakaoMap 키 정보 조회
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
        } else {
            print("Kakao App Key is missing in Info.plist")
        }
    }
    
    var body: some View {
        VStack {
            SegmentControlsComponent(selectSegment: $viewModel.selectSegment)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
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
                KakaoMapView(
                    draw: $draw,
                    markerCoordinate: CLLocationCoordinate2D(
                        latitude: UserLocation.shared.userLat,
                        longitude: UserLocation.shared.userLon
                    ),
                    defaultLevel: 5,
                    tourList: placeItemToDetailModel(from: viewModel.items)
                ).padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            
        }
        .navigationTitle("방문한 관광지")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(Color.primaryColor)
                .onTapGesture {
                    dismiss()
                }
            }
        }
        .onAppear {
            // fetch Data
            viewModel.fetchGroupedItemsByLocation()
            draw = true
        }
        .onDisappear { draw = false }
    }
    
    /// PlaceItem -> DetailModel 모델링
    private func placeItemToDetailModel(from placeItem: [PlaceItem]) -> [DetailModel] {
        var ret = [DetailModel]()
        
        for item in placeItem {
            ret.append(
                DetailModel(tid: nil, tlid: nil, stid: nil, stlid: item.stlid, themeCategory: nil, category: nil, addr1: item.addr1, addr2: item.addr2, title: item.title, mapX: item.mapX, mapY: item.mapY, audioTitle: item.audioTitle, script: item.script, playTime: item.playTime, audioUrl: item.audioURL, langCheck: nil, langCode: item.lanCode, imageUrl: item.imageUrl, createdTime: nil, modifiedtime: nil)
            )
        }
        
        return ret
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
            Image("NoneData")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: 지역별로 묶인 Row
    private func placeItemList(listItems: [PlaceItem]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let locationName = listItems.first?.loc {
                Text(locationName)
                    .font(Font.system(size: 20, weight: .bold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(listItems, id: \.self) { item in
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
                            .frame(width: 70, height: 70)
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
                        .stroke(colorScheme == .dark ? Color.secondaryColorBlack : Color.white, lineWidth: 4)
                        .shadow(radius: 3)
                )
                Spacer()
                // 관광지 이름
                Text(item.title)
                    .foregroundStyle(Color.textColor)
                    .font(.system(size: 14, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                Spacer()
                    .frame(height: 8)
            }
            .frame(maxWidth: 100, maxHeight: 140)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? Color.secondaryColorBlack : Color.white)
                    .stroke(colorScheme == .dark ? Color.clear : Color.black40, lineWidth: 1)
                )
            )
        }
}

