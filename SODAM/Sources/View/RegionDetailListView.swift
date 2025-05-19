//
//  RegionDetailListView.swift
//  SODAM
//
//  Created by 김용해 on 5/16/25.
//

import SwiftUI

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
                    ProgressView()
                }else {
                    ScrollView {
                        ForEach(viewModel.regionList, id: \.tid) { item in
                            tourItem(item: item)
                            Divider()
                        }
                    }
                }
            case .map:
                ScrollView {
                    Text("Map Page")
                }
            }
        }
        .navigationTitle(viewModel.region.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    private func tourItem(item: DetailModel) -> some View {
        guard let image = item.imageUrl,let addr1 = item.addr1 else { return AnyView(ProgressView()) }
        print(image)
        return AnyView(
            HStack {
                Image("Seoul")
                    .resizable()
                    .aspectRatio(1,contentMode: .fit)
                    .frame(minWidth: 70, maxHeight: 70)
                    .clipShape(.rect(cornerRadius: 12))
                    
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 1)
                    Text(addr1)
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
    RegionDetailListView(region: Region(name: "서울", latitude: 37.5665, longitude: 126.9780, imageName: "Seoul"))
}


class RegionDetailListViewModel: ObservableObject {
    @Published var region: Region // region 받아오기
    @Published var selectSegment: SegmentState = .list
    @Published var regionList: [DetailModel] = []
    @Published var isLoading: Bool = false
    
    init(region: Region) {
        self.region = region
        fetchRegionListData()
    }
    
    // MARK: 위치 기반 관광지 데이터 가져오기
    private func fetchRegionListData() {
        Task {
            isLoading = true
            do {
                regionList = try await APIService.shared.getThemeLocationBasedList(lng: region.longitude, lat: region.latitude, radius: 10000, numOfRows: 8, pageNo: 1)
            } catch {
                print("리스트 불러오기 실패: \(error)")
            }
            isLoading = false
        }
    }
}
