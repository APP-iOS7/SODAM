//
//  RegionDataCacheManager.swift
//  SODAM
//
//  Created by 김용해 on 5/22/25.
//

@MainActor
class RegionDataCacheManager {
    static let shared: RegionDataCacheManager = .init()
    
    // viewModel 캐시 저장소
    private var cacheViewModel: [String : RegionDetailListViewModel] = [:]
    
    // 존재하는 viewModel인지 판단
    func get(region: Region) -> RegionDetailListViewModel {
        if let cachedViewModel = cacheViewModel[region.name] {
            return cachedViewModel
        }else {
            let newViewModel = RegionDetailListViewModel(region: region)
            cacheViewModel[region.name] = newViewModel
            
            // 여기서 병렬 처리
            Task {
                newViewModel.fetchRegionListData()
            }
            return newViewModel
        }
    }
}
