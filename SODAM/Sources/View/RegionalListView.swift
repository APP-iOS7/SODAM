//
//  RegionalListView.swift
//  SODAM
//
//  Created by 김용해 on 5/15/25.
//

import SwiftUI
import UICommonExtension

struct RegionalListView: View {
    // viewModel 을 위한 싱글 톤
    let cache = RegionDataCacheManager.shared
    
    // grid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        GeometryReader { geo in
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(regions) { region in
                    NavigationLink(
                        destination: RegionDetailListView(viewModel: cache.get(region: region))
                    ) {
                        gridItem(region: region, geo: geo)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("지역 선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("뒤로가기")
                }
                .foregroundStyle(Color.primaryColor)
                .onTapGesture {
                    dismiss()
                }
            }
        }
    }
    
    // MARK: 각 GridItem
    private func gridItem(region: Region, geo: GeometryProxy) -> some View {
        Image(region.imageName)
            .resizable()
            .frame(maxWidth: .infinity)
            .frame(height: geo.size.height * 0.17)
            .clipShape(.rect(cornerRadius: 15))
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black.opacity(0.4))
                    
                    Text(region.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
    }
}

#Preview {
    NavigationStack {
        RegionalListView()
    }
}

// MARK: 확장을 통해 데이터 가져오기
extension RegionalListView {
    var regions: [Region] {
        [
            Region(name: "서울", latitude: 37.5665, longitude: 126.9780, imageName: "seoul"),
            Region(name: "강원", latitude: 37.8228, longitude: 128.1555, imageName: "gangwon"),
            Region(name: "경북", latitude: 36.4919, longitude: 128.8889, imageName: "gyeongbuk"),
            Region(name: "경남", latitude: 35.4606, longitude: 128.2132, imageName: "gyeongnam"),
            Region(name: "충북", latitude: 36.6357, longitude: 127.4917, imageName: "chungbuk"),
            Region(name: "충남", latitude: 36.5184, longitude: 126.8000, imageName: "chungnam"),
            Region(name: "경기", latitude: 37.4138, longitude: 127.5183, imageName: "gyeonggi"),
            Region(name: "제주", latitude: 33.3717, longitude: 126.5520, imageName: "jeju"),
            Region(name: "전북", latitude: 35.7167, longitude: 127.1441, imageName: "jeonbuk"),
            Region(name: "전남", latitude: 34.8746, longitude: 126.9865, imageName: "jeonnam")
        ]
    }

}
