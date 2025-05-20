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
    
    private var dataManager: DataManager?
    
    func setContext(_ context: ModelContext) {
        self.dataManager = DataManager(modelContext: context)
    }
    
    func fetchItems() {
        do {
            let fetchedItems = try dataManager?.fetchPlaceItems()
            items = fetchedItems ?? []
        } catch {
            print("Failed to fetch items:", error)
        }
    }

    func addItem(item: PlaceItem) {
        Task {
            do {
                try await dataManager?.addPlaceItem(item: item)
                fetchItems()
            } catch {
                print("Failed to add item:", error)
            }
        }
    }
    
    // fetch + grouping → 지역이름으로 정렬한 후 [[PlaceItem]] 반환
    func fetchGroupedItemsByLocation() {
        do {
            let fetchedItems = try dataManager?.fetchPlaceItems() ?? []
            items = fetchedItems

            let groupedDict = Dictionary(grouping: fetchedItems) { $0.loc ?? "Unknown" }

            // loc 기준 오름차순 정렬
            listItems = groupedDict.values
                .sorted {
                    let loc1 = $0.first?.loc ?? "Unknown"
                    let loc2 = $1.first?.loc ?? "Unknown"
                    return loc1 < loc2
                }

        } catch {
            print("Failed to fetch and group items:", error)
        }
    }


}

