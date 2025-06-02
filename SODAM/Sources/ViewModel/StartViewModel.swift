//
//  StartViewModel.swift
//  SODAM
//
//  Created by 김태건 on 5/22/25.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class StartViewModel: ObservableObject {
  @Published var theme: [DetailModel] = []
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    let locationPub = UserLocation.shared.$currentLocation
      .compactMap { $0?.coordinate }
    
    let distinctPub = locationPub
      .removeDuplicates { old, new in
        old.latitude == new.latitude &&
        old.longitude == new.longitude
      }
    
    distinctPub
      .sink { [weak self] coord in
        Task { await self?.callAPI(lon: coord.longitude, lat: coord.latitude) }
      }
      .store(in: &cancellables)
  }
  
  func callAPI(
    lon: Double,
    lat: Double,
    radius: Int = 10000,
    numOfRows: Int = 10,
    pageNo: Int = 1
  ) async {
    isLoading = true
    errorMessage = nil
    
    do {
      let items = try await APIService.shared.getThemeLocationBasedList(
        lng: lon,
        lat: lat,
        radius: radius,
        numOfRows: numOfRows,
        pageNo: pageNo
      )
//      print("[D]API Data \n\(items)")
      theme = items
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
}
