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
  @ObservedObject var viewModel: StartViewModel
  
  var body: some View {
    VStack {
      Capsule()
        .frame(width: 40, height: 5)
        .foregroundStyle(.secondary)
        .padding(.top, 10)
      
      Text("지금 들을 수 있는 이야기")
        .font(.system(size: 20))
        .fontWeight(.bold)
        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ScrollView {
        LazyVStack(){
          ForEach(viewModel.theme, id: \.self){ theme in
            TouristSpotTestView(viewModel: viewModel, theme: theme)
          }
          
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(.white)
    .clipShape(
      RoundedCorner(
        radius: 20,
        corners: [.topLeft, .topRight]
      )
    )
  }
}

// 250521 1605 KTG
// 테스트용
struct TouristSpotTestView: View {
  @EnvironmentObject private var userLocation: UserLocation
  @ObservedObject var viewModel: StartViewModel
  let theme: DetailModel
  let imageUrl: String = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
  let playTime = 61
  
  var body: some View {
    HStack {
      AsyncImage(url: URL(string: imageUrl)) { image in
        image.resizable()
      } placeholder: {
        ProgressView()
      }
      .frame(width: 70, height: 70)
      .cornerRadius(10)
      
      VStack(alignment: .leading) {
        Text("\(theme.title)")
          .foregroundStyle(Color.black)
          .fontWeight(.semibold)
          .padding(.top, 2)
        Text("\(theme.addr1 ?? "") \(theme.addr2 ?? "주소를 알 수 없습니다.")")
          .font(.caption)
          .foregroundStyle(.gray)
        HStack {
          Image(systemName: "mappin.and.ellipse")
            .font(.footnote)
            .foregroundStyle(.gray)
          if let lat2 = Double(theme.mapY), let lon2 = Double(theme.mapX) {
            Text("\(haversineDistance(lat1: userLocation.userLat, lon1: userLocation.userLon, lat2: lat2, lon2: lon2), specifier: "%.2f") km")
              .font(.footnote)
              .foregroundStyle(.gray)
          } else {
            Text("거리를 알 수 없습니다.")
              .font(.footnote)
              .foregroundStyle(.gray)
          }
        }
        .padding(.top, 3)
      }
      .padding(.leading, 5)
      
      Spacer()
      
      HStack(alignment: .center) {
        Text(
          "\(String(format: "%02d", theme.playTime ?? 00 / 60)):\(String(format: "%02d", theme.playTime ?? 00 % 60))"
        )
          .font(.system(size: 16))
        Image(systemName: "play.circle")
          .fontWeight(.bold)
          .font(.system(size: 16))
      }
      .foregroundStyle(Color.black)
      .padding(.trailing, 5)
    }
  }
  
}

//#Preview {
//  NearTouristSpotView(viewModel: StartViewModel(), theme: DetailModel)
//}
