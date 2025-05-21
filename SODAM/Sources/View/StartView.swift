//
//  StartView.swift
//  SODAM
//
//  Created by 김태건 on 5/15/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

extension Notification.Name {
  static let sheetVisibleHeightChanged = Notification.Name("sheetVisibleHeightChanged")
}

struct StartView: View {
  @EnvironmentObject private var userLocation: UserLocation
  @State private var sheetOffset: CGFloat = 0
  @State private var lastDragValue: CGFloat = 0
  
  var body: some View {
    GeometryReader { proxy in
      // 아이폰 16 프로
      // totalHeight : 690
      // safeTop : 62
      // safeBottom : 0
      let totalHeight = proxy.size.height
//      let safeTop = proxy.safeAreaInsets.top
      let safeBottom = proxy.safeAreaInsets.bottom
      
      let closedHeight = totalHeight * 0.03
      let openMidHeight = totalHeight * 0.50
      let openFullHeight = totalHeight * 0.97
      
      let closedOffset = totalHeight - safeBottom - closedHeight
      let openMidOffset = totalHeight - safeBottom - openMidHeight
      let openFullOffset = totalHeight - safeBottom - openFullHeight
      
      ZStack(alignment: .bottom) {
        MapView()
          .environmentObject(userLocation)
          .ignoresSafeArea()
          .onChange(of: sheetOffset) { _, newOffset in
            let visibleHeight = totalHeight - newOffset
            NotificationCenter.default.post(
              name: .sheetVisibleHeightChanged,
              object: visibleHeight
            )
          }
        
        NearTouristSpotView()
          .frame(height: totalHeight)
          .offset(y: sheetOffset)
          .gesture(
            DragGesture()
              .onChanged { value in
                let delta = value.translation.height - lastDragValue
                sheetOffset += delta
                lastDragValue = value.translation.height
              }
              .onEnded { _ in
                let snapPoints = [closedOffset, openMidOffset, openFullOffset]
                let closest = snapPoints.min {
                  abs($0 - sheetOffset) < abs($1 - sheetOffset)
                }!
                withAnimation(.interactiveSpring()) {
                  sheetOffset = closest
                }
                lastDragValue = 0
              }
          )
          .onAppear {
            sheetOffset = closedOffset
          }
      }
    }
  }
  
}

//#Preview {
//  SrartView()
//}

