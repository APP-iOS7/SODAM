//
//  DataManager.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//
// SwiftData 연동을 위한 싱글톤 객체
import Foundation
import SwiftData

final class DataManager {
    static let shared = DataManager(modelContext: <#ModelContext#>)
    
    let modelContext: ModelContext
    
    private init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    enum SwiftDataError: Error {
        case modelContextUnavailable
        case insertionFailed
        case deletionFailed
        case fetchFailed
        case invalidSchema
        case migrationError
    }
}
