//
//  NearTouristSpotView.swift
//  SODAM
//
//  Created by 김태건 on 5/19/25.
//

import SwiftUI

struct RoundedCorner: Shape {
  var radius: CGFloat
  var corners: UIRectCorner
  
  func path(in rect: CGRect) -> Path {
    let bezier = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(bezier.cgPath)
  }
}

struct NearTouristSpotView: View {
  var body: some View {
    VStack {
      Capsule()
        .frame(width: 40, height: 6)
        .foregroundStyle(.secondary)
        .padding(.top, 8)
      
      Text("근처 관광지")
        .font(.headline)
        .padding(.top, 30)
      
      List {
        Text("AAA")
        Text("BBB")
        Text("CCC")
        Text("DDD")
        Text("EEE")
      }
      .listStyle(.plain)
    }
    .background(.white)
    .clipShape(
      RoundedCorner(
        radius: 20,
        corners: [.topLeft, .topRight]
      )
    )
  }
}

//#Preview {
//  NearTouristSpotView()
//}
