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
    
    // fetch + grouping → [[PlaceItem]] 반환
    func fetchGroupedItemsByLocation() {
        do {
            let fetchedItems = try dataManager?.fetchPlaceItems() ?? []
            items = fetchedItems
            let groupedDict = Dictionary(grouping: fetchedItems) { $0.loc ?? "Unknown" }
            listItems = groupedDict.values.map { $0 }
        } catch {
            print("Failed to fetch and group items:", error)
        }
    }

}

