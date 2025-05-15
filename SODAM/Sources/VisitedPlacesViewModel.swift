//
//  VisitedPlacesViewModel.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//

import Foundation

@MainActor
class VisitedPlacesViewModel: ObservableObject {
    @Published var visitedPlaces: [PlaceItem] = []
    
    
}
