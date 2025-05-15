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
        do {
            try dataManager?.addPlaceItem(item: item)
            fetchItems()
        } catch {
            print("Failed to add item:", error)
        }
    }

}

