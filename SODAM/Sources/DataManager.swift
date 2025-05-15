//
//  DataManager.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//
// SwiftData 연동을 위한 싱글톤 객체
import SwiftData

@MainActor
final class DataManager {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    enum DataManagerError: Error {
        case insertionFailed
        case deletionFailed
        case fetchFailed
    }

    func addPlaceItem(item: PlaceItem) throws {
        modelContext.insert(item)
        try modelContext.save()
    }

    func deletePlaceItem(_ item: PlaceItem) throws {
        modelContext.delete(item)
        try modelContext.save()
    }

    func fetchPlaceItems() throws -> [PlaceItem] {
        do {
            return try modelContext.fetch(FetchDescriptor<PlaceItem>())
        } catch {
            throw DataManagerError.fetchFailed
        }
    }
}

