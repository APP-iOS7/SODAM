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
  
  var body: some View {
    MapView()
  }
}

//#Preview {
//  SrartView()
//}

