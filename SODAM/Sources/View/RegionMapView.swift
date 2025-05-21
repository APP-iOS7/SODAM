//
//  RegionMapView.swift
//  SODAM
//
//  Created by 김용해 on 5/20/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct RegionMapView: View {
    private let regionLocation: CLLocationCoordinate2D
    private var tourList: [DetailModel]
    @State private var draw: Bool = false
    @State private var selectTour: DetailModel?
    @State private var isDetailActive: Bool = false // 네비게이션 제어용 상태

    init(regionLocation: CLLocationCoordinate2D, tourList: [DetailModel]) {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
        } else {
            print("Kakao App Key is missing in Info.plist")
        }

        self.regionLocation = regionLocation
        self.tourList = tourList
    }

    var body: some View {
        NavigationStack {
            ZStack {
                KakaoMapView(
                    draw: $draw,
                    markerCoordinate: regionLocation,
                    defaultLevel: 10,
                    tourList: tourList,
                    onPoiTapped: { tour in
                        selectTour = tour
                        isDetailActive = true
                    }
                )
            }
            .navigationDestination(isPresented: $isDetailActive) {
                if let tour = selectTour {
                    DetailView(item: tour)
                } else {
                    // fallback (안 뜨게 하고 싶으면 EmptyView())
                    EmptyView()
                }
            }
            .onAppear { draw = true }
            .onDisappear { draw = false }
            .ignoresSafeArea()
        }
    }
}
