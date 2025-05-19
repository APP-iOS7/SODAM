//
//  RegionDetailListViewModel.swift
//  SODAM
//
//  Created by 김용해 on 5/19/25.
//


import Foundation

@MainActor
class RegionDetailListViewModel: ObservableObject {
    @Published var region: Region // region 받아오기
    @Published var selectSegment: SegmentState = .list
    @Published var regionList: [DetailModel] = []
    @Published var isLoading: Bool = false
    @Published var allAddress: [String : String] = .init()
    
    var filteredRegionList: [DetailModel] { // 데이터 필터링
        regionList.filter {
            $0.imageUrl != nil &&
            $0.imageUrl?.isEmpty == false &&
            $0.audioUrl != nil &&
            $0.audioUrl?.isEmpty == false
        }
    }
    
    init(region: Region) {
        self.region = region
        fetchRegionListData()
    }
    
    // MARK: 위치 기반 관광지 데이터 가져오기
    private func fetchRegionListData() {
        Task {
            isLoading = true
            do {
                regionList = try await APIService.shared.getStoryLocationBasedList(lng: region.longitude, lat: region.latitude, radius: 10000, numOfRows: 100, pageNo: 1)
                try await fetchRegionGetAddress()
            } catch {
                print("리스트 불러오기 실패: \(error)")
            }
            isLoading = false
        }
    }
    
    // MARK: 각각의 관광지 주소 가져오는 함수
    private func fetchRegionGetAddress() async throws {
        for region in filteredRegionList {
            // 이미 주소가 있으면 넘어감
            if let addr1 = region.addr1, !addr1.isEmpty,
            let addr2 = region.addr2, !addr2.isEmpty {
                continue
            }
            let x = Double(region.mapX!)!
            let y = Double(region.mapY!)!
            
            do {
                let address = try await APIService.shared.getAddress(x: x, y: y)
                allAddress[region.stlid!] = address?.response.result?.first?.text
            } catch {
                print("주소 값 가져오기 실패 : \(error)")
            }
        }
    }
}

