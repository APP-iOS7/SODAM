//
//  DetailViewModel.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//

import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    @Published var item: DetailModel?
    @Published var items: [DetailModel]?
    @Published var isLoading: Bool = false
    
    private let apiService = APIService()

    func fetchDetailInfo(keyword: String, pageNo: Int = 1) {
        Task {
            isLoading = true
            do {
                let fetchedItems = try await apiService.getThemeSearchList(keyword: keyword, numOfRows: 1, pageNo: pageNo)
                self.item = fetchedItems.first
            } catch {
                print("오디오 리스트 불러오기 실패: \(error)")
                self.item = nil
            }
            isLoading = false
        }
    }
    
    // 테스트용
    func fetch() {
        Task {
            do {
                try await apiService.getAddress(x: 126.9223, y: 37.4985)
            } catch {
                print("위치 불러오기 실패: \(error)")
            }
            
        }
    }
}
