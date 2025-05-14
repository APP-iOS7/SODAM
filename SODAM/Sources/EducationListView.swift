//
//  EducationDetailView.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import SwiftUI

struct EducationListView: View {
    var spots: [Spot] = [
        Spot(title: "안산 대부도", address: "경기도 안산시", position: 54.8),
        Spot(title:"수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),
        Spot(title: "오이도", address: "경기도 사흥시", position: 38.7),
        Spot(title: "수원 남문로데오 시장", address: "경기도 수원시", position: 29.9),
        Spot(title: "오이도", address: "경기도 사흥시", position: 38.7)
    ]
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(spots) { spot in
                    NavigationLink {
                        //TODO: DetailView 연결
                    } label: {
                        EducationListCellView(spot: spot)
                    }
                }
                Spacer()
            }
        }
    }
}

struct EducationListCellView: View {
    let spot: Spot
    let playTime = 176
    let imageUrl: String = "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/9072.jpg"
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                VStack(alignment: .leading) {
                    Text(spot.title)
                        .foregroundStyle(Color.black)
                    Text(spot.address)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(.leading, 5)
                Spacer()
            }
            HStack(alignment: .center) {
                Text("\(String(format: "%02d", playTime / 60)):\(String(format: "%02d", playTime % 60))")
                Image(systemName: "play.circle")
            }
            .foregroundStyle(Color.black)
            .padding(.trailing, 30)
        }
        .padding([.leading, .trailing], 5)
    }
}

#Preview {
    EducationListView()
}
