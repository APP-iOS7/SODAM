//
//  MapView.swift
//  SODAM
//
//  Created by 김용해 on 05/14/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct MapView: View {
    @Binding var draw: Bool
    @EnvironmentObject private var userLocation: UserLocation
    let tourList: [DetailModel]
    
    init(
        draw: Binding<Bool>,
        tourList: [DetailModel]
    ) {
        self._draw = draw
        self.tourList = tourList
        
        if let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: key)
//            print("[D]Key OK")
        } else {
            print("[D]ERROR 1")
        }
    }
    
    var body: some View {
        KakaoMapStartView(
            draw: $draw,
            markerCoordinate: userLocation.currentLocation?.coordinate,
            tourList: tourList
        )
        .environmentObject(userLocation)
        .onAppear{
            userLocation.startUpdatingLocation()
            draw = true
        }
        .onDisappear{
            draw = false
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .ignoresSafeArea(edges: .top)
    }
}
