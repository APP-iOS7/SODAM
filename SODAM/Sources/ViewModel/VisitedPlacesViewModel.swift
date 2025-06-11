//
//  VisitedPlacesViewModel.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//

import Foundation
import SwiftData

@MainActor
final class VisitedPlacesViewModel: ObservableObject {
    @Published var items: [PlaceItem] = []
    @Published var listItems: [[PlaceItem]] = [[]]
    @Published var isLoading: Bool = false
    @Published var selectSegment: SegmentState = .list

    /// SwiftData에 저장된 placeItem을 불러옵니다.
    func fetchItems() {
        do {
            let fetchedItems = try DataManager.shared.fetchPlaceItems()
            items = fetchedItems
        } catch {
            print("Failed to fetch items:", error)
        }
    }
    
    // fetch + grouping → 지역이름으로 정렬한 후 [[PlaceItem]] 반환
    func fetchGroupedItemsByLocation() {
        do {
            let fetchedItems = try DataManager.shared.fetchPlaceItems()
            items = fetchedItems

            print("✅ fetchedItems count: \(fetchedItems.count)")
            
            let groupedDict = Dictionary(grouping: fetchedItems) { $0.loc ?? "Unknown" }
            print("📌 groupedDict keys: \(groupedDict.keys)")
            
            listItems = groupedDict.values.sorted {
                let loc1 = $0.first?.loc ?? "Unknown"
                let loc2 = $1.first?.loc ?? "Unknown"
                return loc1 < loc2
            }
            
            print("📋 listItems count: \(listItems.count)")


        } catch {
            print("Failed to fetch and group items:", error)
        }
    }
}

