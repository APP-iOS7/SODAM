//
//  RegionDetailListView.swift
//  SODAM
//
//  Created by 김용해 on 5/16/25.
//

import SwiftUI
import CoreLocation
import KakaoMapsSDK

struct RegionDetailListView: View {
    @StateObject var viewModel: RegionDetailListViewModel
    
    init(region: Region) {
        _viewModel = StateObject(wrappedValue: .init(region: region))
    }
    
    var body: some View {
        VStack {
            SegmentControlsComponent(selectSegment: $viewModel.selectSegment)
            switch viewModel.selectSegment {
                case .list:
                    if viewModel.isLoading {
                        loadingView
                    }else {
                        if viewModel.filteredRegionList.isEmpty {
                            isEmptyView
                        }else {
                            ScrollView {
                                ForEach(viewModel.filteredRegionList, id: \.self) { item in
                                    tourItem(item: item)
                                    Divider()
                                }
                            }
                        }
                    }
                case .map:
                RegionMapView(regionLocation: CLLocationCoordinate2D(latitude: viewModel.region.latitude, longitude: viewModel.region.longitude), tourList: viewModel.filteredRegionList)
                }
        }
        .navigationTitle(viewModel.region.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    // MARK: isLoading이 true일 동안의 View
    private var loadingView: some View {
        VStack {
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: regionList에 데이터가 없을 경우
    private var isEmptyView: some View {
        VStack {
            Text("데이터가 없습니다 ㅠ..ㅠ")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: 지역 관광지 각 Row
    private func tourItem(item: DetailModel) -> some View {
        guard let stlid = item.stlid else {return AnyView(ProgressView())}
        return AnyView(
            HStack {
                AsyncImage(url: URL(string: item.imageUrl!)) {
                    $0.resizable()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(minWidth: 70, maxHeight: 70)
                }
                .aspectRatio(1,contentMode: .fit)
                .frame(minWidth: 70, maxHeight: 70)
                .clipShape(.rect(cornerRadius: 12))
                
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 1)
                    Text(viewModel.allAddress[stlid] ?? "주소가 없습니다")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black60)
                    Spacer()
                }
                Spacer()
            }
                .frame(maxWidth: .infinity, maxHeight: 80)
        )
    }
}

#Preview {
    RegionDetailListView(region:
        Region(name: "서울", latitude: 37.5665, longitude: 126.9780, imageName: "seoul")
//        데이터가 없는 경우
//        Region(name: "강원", latitude: 37.8228, longitude: 128.1555, imageName: "gangwon")
    )
}
