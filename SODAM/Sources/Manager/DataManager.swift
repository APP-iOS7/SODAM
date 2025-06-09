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
    static let shared = DataManager()

    private var modelContext: ModelContext!

    private init() { }
    
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    enum DataManagerError: Error {
        case insertionFailed
        case deletionFailed
        case fetchFailed
    }

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
            
            
            guard existingItems.isEmpty else {
                print("⚠️ 중복된 아이템이 이미 존재합니다: \(item.title), \(item.mapX), \(item.mapY)")
                return
            }
            
            let address = try await APIService.shared.getAddress(x: x, y: y)
            item.loc = address?.response.result?.first?.structure?.level1
            modelContext.insert(item)
            try modelContext.save()
            print("✅ 저장 성공")
        } catch {
            print("❌ 저장 실패: \(error.localizedDescription)")
            dump(error)
            throw DataManagerError.insertionFailed
        }
        
    }
    
    func deletePlaceItem(_ item: PlaceItem) throws {
        do {
            modelContext.delete(item)
            try modelContext.save()
            print("✅ 삭제 성공")
        } catch {
            print("❌ 저장 실패: \(error.localizedDescription)")
            throw DataManagerError.deletionFailed
        }
    }

    func fetchPlaceItems() throws -> [PlaceItem] {
        do {
            return try modelContext.fetch(FetchDescriptor<PlaceItem>())
        } catch {
            throw DataManagerError.fetchFailed
        }
    }
}
