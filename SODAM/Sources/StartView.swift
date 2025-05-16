//
//  StartView.swift
//  SODAM
//
//  Created by 김태건 on 5/15/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct StartView: View {
  @StateObject private var userLocation = UserLocation.shared
  @State private var draw = false
  
  var body: some View {
    MapView()
      .environmentObject(userLocation)
      .onAppear {
        userLocation.startUpdatingLocation()
        draw = true
      }
      .onDisappear {
        draw = false
      }
  }
}

//#Preview {
//  SrartView()
//}

