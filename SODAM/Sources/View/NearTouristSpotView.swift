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
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundStyle(.secondary)
                .padding(.top, 10)
            
            Text("지금 들을 수 있는 이야기")
                .foregroundStyle(Color.textColor)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.theme.isEmpty {
                isEmptyView
            } else {
                ScrollView {
                    LazyVStack {
                        Divider()
                        ForEach(viewModel.theme, id: \.self) { theme in
                            TouristSpotTestView(viewModel: viewModel, theme: theme)
                            Divider()
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 100, trailing: 20))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(UIColor.systemBackground))
        .clipShape(
            RoundedCorner(
                radius: 20,
                corners: [.topLeft, .topRight]
            )
        )
    }
}

struct TouristSpotTestView: View {
    @EnvironmentObject private var userLocation: UserLocation
    @ObservedObject var viewModel: StartViewModel
    let theme: DetailModel
    let playTime = 61
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: theme.imageUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("\(theme.title)")
                    .foregroundStyle(Color.textColor)
                    .fontWeight(.semibold)
                    .padding(.top, 2)
                Text("\(theme.addr1 ?? "주소를 확인할 수 없습니다.") \(theme.addr2 ?? "")")
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
                Text("\(String(format: "%02d", (Int(theme.playTime ?? "0") ?? 0) / 60)):\(String(format: "%02d", (Int(theme.playTime ?? "0") ?? 0 ) % 60))")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.textColor)
                
                Button {
                    sendPlayState(state: true, spot: theme)
                    
                    // Swift Data Insert
                    Task {
                        await saveItem(theme)
                    }
                } label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .foregroundStyle(.green)
                
            }
            .foregroundStyle(Color.black)
            .padding(.trailing, 5)
        }
    }
    
    // Swift Data로 방문한 관광지 추가하는 기능 추가
    @MainActor
    func saveItem(_ item: DetailModel) async {
        let placeItem = detailItemToPlaceItem(item: item)

        do {
            try await DataManager.shared.addPlaceItem(item: placeItem)
        } catch {
            print(error)
        }
    }

    func detailItemToPlaceItem(item: DetailModel) -> PlaceItem {
        return PlaceItem(title: item.title, stlid: item.stlid, mapX: item.mapX, mapY: item.mapY, audioTitle: item.audioTitle, script: item.script, playTime: item.playTime, audioURL: item.audioUrl, lanCode: item.langCode, imageUrl: item.imageUrl, addr1: item.addr1, addr2: item.addr2)
    }
    
}

private var isEmptyView: some View {
    VStack {
        Image("NoneData")
            .resizable()
            .aspectRatio(contentMode: .fit)
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

//#Preview {
//  NearTouristSpotView(viewModel: StartViewModel(), theme: DetailModel)
//}
