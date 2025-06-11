//
//  DataManager.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//
// SwiftData 연동을 위한 싱글톤 객체

import SwiftData
import Foundation

@MainActor
final class DataManager {
    private var modelContext: ModelContext!
    
    // 싱글톤으로 지정
    static let shared = DataManager()
    private init() { }
    
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // DataManger 실행중 발생하는 오류 정의
    enum DataManagerError: Error {
        case insertionFailed
        case deletionFailed
        case fetchFailed
    }

    /** 장소정보 SwiftData에 추가
     * - Parameters:
     *      - item: 장소 정보를 담은 PlaceItem
     */
    @MainActor
    func addPlaceItem(item: PlaceItem) async throws {
        guard let x = Double(item.mapX), let y = Double(item.mapY) else {
            print("❌ mapX or mapY 값이 Double로 변환 불가: \(item.mapX), \(item.mapY)")
            throw DataManagerError.insertionFailed
        }
        do {
            // MARK: 중복 확인 후 INSERT
            // 중복확인은 title, mapX, mapY로 구분
            let title = item.title
            let mapX = item.mapX
            let mapY = item.mapY
            
            let fetchDescriptor = FetchDescriptor<PlaceItem>(
                predicate: #Predicate { placeItem in
                    placeItem.title == title &&
                    placeItem.mapX == mapX &&
                    placeItem.mapY == mapY
                }
            )
            
            let existingItems = try modelContext.fetch(fetchDescriptor)
            
            
            // 중복된 항목이 있을경우 추가하지 않습니다.
            guard existingItems.isEmpty else {
                print("⚠️ 중복된 아이템이 이미 존재합니다: \(item.title), \(item.mapX), \(item.mapY)")
                return
            }
            
            // 추가하기 전 항목에 location 정보를 추가합니다.
            let address = try await APIService.shared.getAddress(x: x, y: y)
            item.loc = address?.response.result?.first?.structure?.level1
            
            // modelContext에 추가
            modelContext.insert(item)
            
            // modelContext에 상황 저장
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            throw DataManagerError.insertionFailed
        }
        
    }
    
    /** 장소정보 SwiftData에 삭제
     * - Parameters:
     *      - item: 장소 정보를 담은 PlaceItem
     */
    func deletePlaceItem(_ item: PlaceItem) throws {
        do {
            // modelContext에서 항목 삭제
            modelContext.delete(item)
            
            // modelContext에 상황 저장
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            throw DataManagerError.deletionFailed
        }
    }

    /** 장소정보 SwiftData에 삭제
     * - Returns:
     *      - SwiftData에 저장된 모든 PlaceItem의 배열
     */
    func fetchPlaceItems() throws -> [PlaceItem] {
        do {
            return try modelContext.fetch(FetchDescriptor<PlaceItem>())
        } catch {
            throw DataManagerError.fetchFailed
        }
    }
}
